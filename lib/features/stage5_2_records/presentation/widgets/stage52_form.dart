import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:registro_panela/core/services/compress_file.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_form_status.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/app_form_text_fild.dart';
import 'package:registro_panela/shared/widgets/camera_preview_screen.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_from_dropdown.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';
import 'package:uuid/uuid.dart';

class Stage52LoadForm extends ConsumerStatefulWidget {
  final String projectId;
  final Stage52RecordData? initialRecord;
  const Stage52LoadForm({
    super.key,
    required this.projectId,
    this.initialRecord,
  });

  @override
  ConsumerState<Stage52LoadForm> createState() => _Stage52FormPageState();
}

class _Stage52FormPageState extends ConsumerState<Stage52LoadForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late String? _photoPath;
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _photoPath = widget.initialRecord?.photoPath;
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId))!;
    final formState = ref.watch(stage52FormProvider);
    final formNotifier = ref.read(stage52FormProvider.notifier);
    final textTheme = TextTheme.of(context);
    final bool isNew = widget.initialRecord == null;

    return FormBuilder(
      key: _formKey,
      initialValue: widget.initialRecord != null
          ? {
              'gaveras': widget.initialRecord!.gaveraWeight,
              'panelaWeight': widget.initialRecord!.panelaWeight.toString(),
              'unitCount': widget.initialRecord!.unitCount.toString(),
              'quality': widget.initialRecord!.quality.name,
            }
          : {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gavera', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          // 1) Selector de gaveraWeight
          CustomFromDropdown<double>(
            key: Key('stage52-form-gavera-input'),
            name: 'gaveras',
            items: project.gaveras
                .map(
                  (g) => DropdownMenuItem(
                    key: Key('stage52-form-gavera-${g.referenceWeight}'),
                    value: g.referenceWeight,
                    child: Text('${g.referenceWeight} g'),
                  ),
                )
                .toList(),
            validator: FormBuilderValidators.required(
              errorText: "Este campo es obligatorio",
            ),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Peso de panela (kg)', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          // 2) Peso de panela
          AppFormTextFild(
            key: Key('stage52-form-panela-weight-input'),
            name: 'panelaWeight',
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Este campo es obligatorio",
              ),
              FormBuilderValidators.numeric(
                errorText:
                    "Debe de ser un número y si es decimal debe se ser punto en vez de coma",
              ),
            ]),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Unidades de panela', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          // 3) Unidades
          AppFormTextFild(
            key: Key('stage52-form-panela-unit-input'),
            name: 'unitCount',
            keyboardType: TextInputType.number,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Este campo es obligatorio",
              ),
              FormBuilderValidators.integer(
                errorText: "Debe de ser un número entero",
              ),
            ]),
          ),

          const SizedBox(height: AppSpacing.smallLarge),
          Text('Calidad', style: textTheme.headlineLarge),
          const SizedBox(height: AppSpacing.small),
          // 4) Calidad
          CustomFromDropdown(
            key: Key('stage52-form-quality-input'),
            name: 'quality',
            items: BasketQuality.values
                .map(
                  (q) => DropdownMenuItem(
                    key: Key('stage52-form-quality-${q.name}'),
                    value: q.name,
                    child: Text(q.name.toUpperCase()),
                  ),
                )
                .toList(),
            validator: FormBuilderValidators.required(
              errorText: "Este campo es obligatorio",
            ),
          ),

          const SizedBox(height: AppSpacing.mediumLarge),
          // 5) Foto
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              key: Key('stage52-form-photo-button'),
              onPressed: () async {
                _onPickImage(textTheme);
              },
              icon: const Icon(
                Icons.camera_alt,
                color: AppColors.textDark,
                size: 30,
              ),
              label: Text('Tomar foto', style: textTheme.headlineLarge),
            ),
          ),
          if (_photoPath != null) ...[
            const SizedBox(height: AppSpacing.mediumLarge),
            Center(
              child: StageImageWidget(
                imagePath: _photoPath!,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.mediumSmall),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                key: Key('stage52-form-submmit-button'),
                onPressed: formState.status == Stage52FormStatus.submitting
                    ? null
                    : () {
                        if (!(_formKey.currentState?.saveAndValidate() ??
                            false)) {
                          return;
                        }
                        final v = _formKey.currentState!.value;
                        final record = Stage52RecordData(
                          id: widget.initialRecord?.id ?? _uuid.v4(),
                          projectId: widget.projectId,
                          date: widget.initialRecord?.date ?? DateTime.now(),
                          gaveraWeight: v['gaveras'] as double,
                          panelaWeight: double.parse(v['panelaWeight']),
                          unitCount: int.parse(v['unitCount']),
                          quality: BasketQuality.values.firstWhere(
                            (q) => q.name == v['quality'],
                          ),
                          photoPath: _photoPath ?? '',
                        );
                        formNotifier.submit(data: record, isNew: isNew);
                      },
                child: Text('Guardar registro', style: textTheme.headlineLarge),
              ),
            ),
          ),

          if (formState.status == Stage52FormStatus.error)
            Text('Error: ${formState.errorMessage}'),
        ],
      ),
    );
  }

  void _onPickImage(TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCrema,
        title: Text(
          'Seleccionar origen de imagen',
          style: textTheme.headlineMedium,
        ),
        actions: [
          GestureDetector(
            key: Key('stage52-form-camera-button'),
            onTap: () {
              Navigator.of(context).pop();
              _pickFromCamera();
            },
            child: CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: AppColors.textDark,
                      size: 30,
                    ),
                    SizedBox(width: AppSpacing.small),
                    Text(
                      'Cámara',
                      style: textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              _pickFromGallery();
            },
            child: CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.photo_library,
                      color: AppColors.textDark,
                      size: 30,
                    ),
                    SizedBox(width: AppSpacing.small),
                    Text(
                      'Galería',
                      style: textTheme.headlineMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const CameraPreviewScreen()),
    );

    if (imagePath != null) {
      final compressed = await compressFile(imagePath);
      if (compressed != null) {
        setState(() => _photoPath = compressed);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final path = await ref
        .read(imagePickerServiceProvider)
        .pickImage(fromCamera: false);
    if (path != null) {
      final compressedPath = await compressFile(path);
      if (compressedPath != null) {
        setState(() => _photoPath = compressedPath);
      }
    }
  }
}
