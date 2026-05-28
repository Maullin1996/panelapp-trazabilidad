import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:core/core/services/image_picker_service_provider.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage2_load/domain/entities/index.dart';
import 'package:core/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:core/features/stage3_weigh/helpers/comma_to_dot_formatter.dart';
import 'package:core/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class Stage3LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData project;
  final Stage2LoadData load2;
  final Stage3FormData? initialData;
  final bool isNew;

  const Stage3LoadForm({
    required this.project,
    required this.load2,
    this.initialData,
    required this.isNew,
    super.key,
  });

  @override
  ConsumerState<Stage3LoadForm> createState() => _Stage3LoadFormState();
}

class _Stage3LoadFormState extends ConsumerState<Stage3LoadForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  late List<int> _indices;
  late double _refWeightPerBasket;
  late int _totalBaskets;
  late final Uuid _uuid;
  late Map<int, String> _photoPaths; // URLs existentes de Firebase
  final Map<int, Uint8List> _photoBytes = {}; // fotos nuevas capturadas

  @override
  void didUpdateWidget(covariant Stage3LoadForm old) {
    super.didUpdateWidget(old);
    if (old.initialData != widget.initialData) {
      _initFormFields();
      _formKey.currentState?.reset();
    }
  }

  void _initFormFields() {
    final basketsData = widget.initialData?.baskets ?? [];

    // 1) Mapa de sequence → photoPath
    final photoMap = <int, String>{
      for (final b in basketsData) b.sequence: b.photoPath,
    };

    // 2) Genera tu lista de índices
    _totalBaskets = widget.load2.baskets.count;
    _refWeightPerBasket = widget.load2.baskets.referenceWeight;
    _indices = List.generate(_totalBaskets, (i) => i);

    // 3) Llena _photoPaths usando el mapa, o '' si no existe
    _photoPaths = {for (final i in _indices) i: photoMap[i] ?? ''};
  }

  @override
  void initState() {
    super.initState();
    _initFormFields();
    _uuid = const Uuid();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formState = ref.watch(stage3FormProvider);
    final formNotifier = ref.read(stage3FormProvider.notifier);
    final initMap = <String, dynamic>{};
    if (widget.initialData != null) {
      for (final b in widget.initialData!.baskets) {
        initMap['realWeight_${b.sequence}'] = b.realWeight.toString();
        initMap['quality_${b.sequence}'] = b.quality;
      }
    }
    return FormBuilder(
      key: _formKey,
      initialValue: initMap,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.small),
              itemCount: _indices.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == _indices.length) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: AppSpacing.small,
                        right: AppSpacing.small,
                        top: AppSpacing.small,
                        bottom: AppSpacing.small,
                      ),
                      child: SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          key: Key('stage3-load-form-submmit-button'),
                          onPressed:
                              formState.status == Stage3FormStatus.submitting
                              ? null
                              : () async {
                                  if (!(_formKey.currentState
                                          ?.saveAndValidate() ??
                                      false)) {
                                    return;
                                  }
                                  final values = _formKey.currentState!.value;
                                  final existingMap = <int, BasketWeighData>{
                                    for (var b
                                        in widget.initialData?.baskets ?? [])
                                      b.sequence: b,
                                  };

                                  final baskets = <BasketWeighData>[];

                                  for (final i in _indices) {
                                    final raw = values['realWeight_$i'];
                                    final qualStr =
                                        values['quality_$i'] as BasketQuality?;

                                    double? realWeight;
                                    if (raw is num) {
                                      realWeight = raw.toDouble();
                                    } else if (raw is String) {
                                      realWeight = double.tryParse(
                                        raw.replaceAll(',', '.'),
                                      );
                                    }

                                    final hasWeight = realWeight != null;
                                    final hasQuality = qualStr != null;

                                    final prev = existingMap[i];

                                    if (hasWeight && hasQuality) {
                                      baskets.add(
                                        BasketWeighData(
                                          id: prev?.id ?? _uuid.v4(),
                                          sequence: i,
                                          referenceWeight: _refWeightPerBasket,
                                          realWeight: realWeight,
                                          quality: qualStr,
                                          photoPath: _photoPaths[i] ?? '',
                                        ),
                                      );
                                    } else if (prev != null) {
                                      baskets.add(prev);
                                    }
                                  }

                                  final formData = Stage3FormData(
                                    id: widget.initialData?.id ?? _uuid.v4(),
                                    projectId: widget.project.id,
                                    stage2LoadId: widget.load2.id,
                                    date:
                                        widget.initialData?.date ??
                                        DateTime.now(),
                                    baskets: baskets,
                                  );
                                  formNotifier.submit(
                                    formData,
                                    isNew: widget.isNew,
                                    photoBytes: _photoBytes,
                                  );
                                },
                          child: formState.status == Stage3FormStatus.submitting
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LinearProgressIndicator(
                                      value: formState.uploadProgress,
                                      backgroundColor: AppColors.textDark
                                          .withAlpha(50),
                                      color: AppColors.textDark,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formState.totalPhotos == 0
                                          ? 'Guardando...'
                                          : 'Fotos: ${formState.uploadedPhotos}/${formState.totalPhotos}',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  widget.isNew ? 'Register' : 'Actualizar',
                                  style: textTheme.headlineMedium?.copyWith(
                                    color: AppColors.textLight,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  );
                }
                return CustomCard(
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.smallLarge),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryDarkPanela.withAlpha(
                                  20,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small,
                                ),
                                border: Border.all(
                                  color: AppColors.secondaryDarkPanela
                                      .withAlpha(60),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '#${index + 1}',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondaryDarkPanela,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xSmall),
                            Text(
                              'Canastilla',
                              style: textTheme.headlineMedium?.copyWith(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.smallLarge),
                        Text('Peso real (kg)', style: textTheme.headlineMedium),
                        const SizedBox(height: AppSpacing.xSmall),
                        AppFormTextFild(
                          key: Key('stage3-load-form-realWeight$index-input'),
                          name: 'realWeight_$index',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9\.,]'),
                            ),
                            CommaToDotFormatter(),
                          ],
                          valueTransformer: (text) {
                            final s = (text ?? '').toString().trim().replaceAll(
                              ',',
                              '.',
                            );
                            return double.tryParse(s);
                          },
                        ),
                        const SizedBox(height: AppSpacing.smallLarge),
                        Text('Calidad', style: textTheme.headlineMedium),
                        const SizedBox(height: AppSpacing.xSmall),
                        // Cambia el tipo del dropdown
                        CustomFromDropdown<BasketQuality>(
                          key: Key('stage3-load-form-quality$index-input'),
                          name: 'quality_$index',
                          items: BasketQuality.values.map((e) {
                            return DropdownMenuItem<BasketQuality>(
                              key: Key('stage3-load-form-${e.name}-input'),
                              value: e,
                              child: Text(
                                e.label,
                                style: textTheme.bodyLarge,
                              ), // ← .label
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: AppSpacing.smallLarge),
                        if (_photoBytes[index] != null ||
                            _photoPaths[index]?.isNotEmpty == true) ...[
                          const SizedBox(height: 8),
                          Center(
                            child: StageImageWidget(
                              key: Key('stage3_load_form-image-taken'),
                              imageBytes: _photoBytes[index],
                              imageUrl: _photoBytes[index] == null
                                  ? _photoPaths[index]
                                  : null,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.smallLarge),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              key: Key('stage3-load-form-image$index-button'),
                              onPressed: () => _pickImage(index, textTheme),
                              icon: Icon(
                                Icons.camera_alt,
                                color: AppColors.textLight,
                                size: 22,
                              ),
                              label: Text(
                                'Tomar foto',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textLight,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(int index, TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCrema,
        title: Text(
          'Seleccionar origen de imagen',
          style: textTheme.headlineMedium,
        ),
        actions: [
          SelectionSourceTile(
            key: Key('stage3-load-form-take-photo-button'),
            icon: Icons.camera_alt_outlined,
            label: 'Cámara',
            onTap: () {
              Navigator.of(context).pop();
              _pickFromCamera(index);
            },
          ),
          const SizedBox(height: AppSpacing.xSmall),
          SelectionSourceTile(
            icon: Icons.photo_library_outlined,
            label: 'Galería',
            onTap: () {
              Navigator.of(context).pop();
              _pickFromGallery(index);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera(int index) async {
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromCamera(context);
    if (bytes != null) setState(() => _photoBytes[index] = bytes);
  }

  Future<void> _pickFromGallery(int index) async {
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromGallery();
    if (bytes != null) setState(() => _photoBytes[index] = bytes);
  }
}
