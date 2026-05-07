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
import 'package:registro_panela/shared/widgets/field_label.dart';
import 'package:registro_panela/shared/widgets/section_card.dart';
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
    final bool isSubmitting = formState.status == Stage52FormStatus.submitting;

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
          // ── Sección: Gavera ───────────────────────────────────────────
          SectionCard(
            icon: Icons.scale,
            iconColor: AppColors.weight,
            title: 'Gavera',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Seleccionar gavera'),
                const SizedBox(height: AppSpacing.xSmall),
                CustomFromDropdown<double>(
                  key: const Key('stage52-form-gavera-input'),
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
                    errorText: 'Este campo es obligatorio',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Panela ───────────────────────────────────────────
          SectionCard(
            icon: Icons.inventory_2_outlined,
            iconColor: AppColors.primaryPanelaBrown,
            title: 'Panela',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Peso (kg)'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  key: const Key('stage52-form-panela-weight-input'),
                  name: 'panelaWeight',
                  hintText: 'Ej. 12.5',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Este campo es obligatorio',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Solo números, use punto para decimales',
                    ),
                  ]),
                ),
                const SizedBox(height: AppSpacing.smallLarge),
                FieldLabel(textTheme, 'Unidades'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  key: const Key('stage52-form-panela-unit-input'),
                  name: 'unitCount',
                  hintText: 'Ej. 10',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Este campo es obligatorio',
                    ),
                    FormBuilderValidators.integer(
                      errorText: 'Debe ser un número entero',
                    ),
                  ]),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Calidad ──────────────────────────────────────────
          SectionCard(
            icon: Icons.verified_outlined,
            iconColor: AppColors.accepted,
            title: 'Calidad',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Tipo de calidad'),
                const SizedBox(height: AppSpacing.xSmall),
                CustomFromDropdown(
                  key: const Key('stage52-form-quality-input'),
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
                    errorText: 'Este campo es obligatorio',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Foto ─────────────────────────────────────────────
          SectionCard(
            icon: Icons.camera_alt_outlined,
            iconColor: AppColors.error,
            title: 'Registro fotográfico',
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    key: const Key('stage52-form-photo-button'),
                    onPressed: () => _onPickImage(textTheme),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      backgroundColor: AppColors.primaryPanelaBrown,
                    ),
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textLight,
                      size: 20,
                    ),
                    label: Text(
                      _photoPath == null ? 'Tomar foto' : 'Cambiar foto',
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_photoPath != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: StageImageWidget(
                      imagePath: _photoPath!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.medium),

          // ── Error ─────────────────────────────────────────────────────
          if (formState.status == Stage52FormStatus.error) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.small),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(20),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.error.withAlpha(60)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 18),
                  const SizedBox(width: AppSpacing.xSmall),
                  Expanded(
                    child: Text(
                      formState.errorMessage ?? 'Error desconocido',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.small),
          ],

          // ── Botón guardar ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('stage52-form-submmit-button'),
              onPressed: isSubmitting
                  ? null
                  : () => _onSubmit(formNotifier, isNew),
              child: isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: AppColors.cardBackground,
                      ),
                    )
                  : Text(
                      isNew ? 'Guardar registro' : 'Actualizar registro',
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.cardBackground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.medium),
        ],
      ),
    );
  }

  void _onSubmit(Stage52Form formNotifier, bool isNew) {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    final v = _formKey.currentState!.value;
    final record = Stage52RecordData(
      id: widget.initialRecord?.id ?? _uuid.v4(),
      projectId: widget.projectId,
      date: widget.initialRecord?.date ?? DateTime.now(),
      gaveraWeight: v['gaveras'] as double,
      panelaWeight: double.parse(v['panelaWeight']),
      unitCount: int.parse(v['unitCount']),
      quality: BasketQuality.values.firstWhere((q) => q.name == v['quality']),
      photoPath: _photoPath ?? '',
    );
    formNotifier.submit(data: record, isNew: isNew);
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
