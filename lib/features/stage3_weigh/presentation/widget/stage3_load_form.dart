import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_form_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:uuid/uuid.dart';

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
  late final List<int> _indices;
  late final double _refWeightPerBasket;
  late final int _totalBaskets;
  late final Map<int, String> _photoPaths;

  @override
  void didUpdateWidget(covariant Stage3LoadForm old) {
    super.didUpdateWidget(old);
    if (old.initialData != widget.initialData) {
      // Reconstruir initMap y _photoPaths aquí
      _initFormFields();
      // Y forzar al FormBuilder a resetearse:
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
  }

  Future<void> _pickImage(int index) async {
    final service = ref.read(imagePickerServiceProvider);
    final path = await service.pickImage(fromCamera: true);
    if (path != null) {
      setState(() {
        _photoPaths[index] = path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final formState = ref.watch(stage3FormProvider);
    final formNotifier = ref.read(stage3FormProvider.notifier);
    final uuid = const Uuid();
    final initMap = <String, dynamic>{};
    if (widget.initialData != null) {
      for (final b in widget.initialData!.baskets) {
        initMap['realWeight_${b.sequence}'] = b.realWeight.toString();
        initMap['quality_${b.sequence}'] = b.quality.name;
      }
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: AppSpacing.medium),
      child: FormBuilder(
        key: _formKey,
        initialValue: initMap,
        child: Column(
          children: [
            ...List.generate(
              _indices.length,
              (index) => CustomCard(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Canastilla #${index + 1}',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Peso real (kg)', style: textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      AppFormTextFild(
                        name: 'realWeight_$index',
                        label: 'Peso real (kg)',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      Text('Calidad', style: textTheme.headlineMedium),
                      const SizedBox(height: 8),

                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(1, 1),
                              color: Colors.black.withAlpha(50),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(AppRadius.small),
                          border: Border.all(
                            color: AppColors.secondaryDarkPanela,
                            width: 2,
                          ),
                        ),
                        child: FormBuilderDropdown<String>(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.small,
                            vertical: AppSpacing.small,
                          ),
                          name: 'quality_$index',
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          items: BasketQuality.values.map((e) {
                            return DropdownMenuItem(
                              value: e.name,
                              child: Text(
                                e.name.toUpperCase(),
                                style: textTheme.bodyLarge,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => _pickImage(index),
                            icon: const Icon(
                              Icons.camera_alt,
                              color: AppColors.textDark,
                              size: 30,
                            ),
                            label: Text(
                              'Tomar foto',
                              style: textTheme.headlineLarge,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.smallLarge),
                      if (_photoPaths[index]?.isNotEmpty == true) ...[
                        const SizedBox(height: 8),
                        (_photoPaths[index]!.startsWith('http'))
                            ? Center(
                                child: Image.network(
                                  _photoPaths[index]!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Image.file(
                                  File(_photoPaths[index]!),
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            SafeArea(
              child: SizedBox(
                height: 60,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: formState.status == Stage3FormStatus.submitting
                      ? null
                      : () async {
                          if (!(_formKey.currentState?.saveAndValidate() ??
                              false)) {
                            return;
                          }
                          final values = _formKey.currentState!.value;
                          final baskets = <BasketWeighData>[];
                          for (final i in _indices) {
                            final raw = values['realWeight_$i'] as String?;
                            final qual = values['quality_$i'] as String?;
                            if (raw != null &&
                                raw.isNotEmpty &&
                                qual != null &&
                                qual.isNotEmpty) {
                              baskets.add(
                                BasketWeighData(
                                  id:
                                      widget.initialData?.baskets[i].id ??
                                      uuid.v4(),
                                  sequence: i,
                                  referenceWeight: _refWeightPerBasket,
                                  realWeight: double.parse(raw),
                                  quality: BasketQuality.values.firstWhere(
                                    (q) => q.name == qual,
                                  ),
                                  photoPath: _photoPaths[i] ?? '',
                                ),
                              );
                            }
                          }
                          final formData = Stage3FormData(
                            id: widget.initialData?.id ?? uuid.v4(),
                            projectId: widget.project.id,
                            stage2LoadId: widget.load2.id,
                            date: widget.initialData?.date ?? DateTime.now(),
                            baskets: baskets,
                          );
                          formNotifier.submit(formData, isNew: widget.isNew);
                        },
                  child: formState.status == Stage3FormStatus.submitting
                      ? const CircularProgressIndicator()
                      : Text(
                          widget.isNew ? 'Register' : 'Actualizar',
                          style: textTheme.headlineLarge,
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
