import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/core/services/compress_file.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/two_form_row.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_form_provider.dart';
import 'package:registro_panela/shared/widgets/field_label.dart';
import 'package:registro_panela/shared/widgets/section_card.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

class Stage1LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData? initialData;
  final bool isNew;
  const Stage1LoadForm({required this.isNew, this.initialData, super.key});

  @override
  ConsumerState<Stage1LoadForm> createState() => _Stage1FormState();
}

class _Stage1FormState extends ConsumerState<Stage1LoadForm> {
  late final GlobalKey<FormBuilderState> _formKey;
  late final List<int> _gaveras;
  late final Uuid _uuid;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
    _gaveras = widget.initialData?.gaveras.asMap().keys.toList() ?? [0];
    _photoPath = widget.initialData?.photoPath;
    _uuid = const Uuid();
  }

  void _addGavera() => setState(() => _gaveras.add(_gaveras.length));

  void _removeGavera(int index) => setState(() => _gaveras.remove(index));

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialData;
    final state = ref.watch(stage1FormProvider);
    //final isNew = widget.isNew;
    final formNotifier = ref.read(stage1FormProvider.notifier);
    final textTheme = TextTheme.of(context);
    final isSubmitting = state.status == Stage1FormStatus.submitting;

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initial == null
          ? {}
          : {
              'name': initial.name,
              'basketsQuantity': initial.basketsQuantity.toString(),
              'preservativesWeight': initial.preservativesWeight.toString(),
              'preservativesJars': initial.preservativesJars.toString(),
              'limeWeight': initial.limeWeight.toString(),
              'limeJars': initial.limeJars.toString(),
              'phone': initial.phone,
              ...{
                for (int i = 0; i < initial.gaveras.length; i++)
                  'gaverasCantidad_$i': initial.gaveras[i].quantity.toString(),
                for (var i = 0; i < initial.gaveras.length; i++)
                  'gaverasPeso_$i': initial.gaveras[i].referenceWeight
                      .toString(),
              },
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Sección: Información general ──────────────────────────────
          SectionCard(
            icon: Icons.storefront_outlined,
            iconColor: AppColors.primaryPanelaBrown,
            title: 'Información general',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Nombre molienda'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  key: const Key('stage1-load-form-molienda-name-input'),
                  name: 'name',
                  hintText: 'Ej. Molienda El Paraíso',
                  validator: FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Gaveras ──────────────────────────────────────────
          SectionCard(
            icon: Icons.storage,
            iconColor: AppColors.weight,
            title: 'Gaveras',
            trailing: _AddButton(
              key: const Key('stage1-load-form-add-gaveras-button'),
              onTap: _addGavera,
            ),
            child: Column(
              children: [
                // Cabeceras de columna
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Cantidad',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textDark.withAlpha(140),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xSmall),
                      Expanded(
                        child: Text(
                          'Peso gavera (g)',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textDark.withAlpha(140),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      if (_gaveras.length > 1) const SizedBox(width: 40),
                    ],
                  ),
                ),
                ..._gaveras.map(
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppFormTextFild(
                            name: 'gaverasCantidad_$index',
                            hintText: '0',
                            keyboardType: TextInputType.number,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: 'Requerido',
                              ),
                              FormBuilderValidators.integer(
                                errorText: 'Solo números',
                              ),
                              FormBuilderValidators.min(1),
                            ]),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xSmall),
                        Expanded(
                          child: AppFormTextFild(
                            name: 'gaverasPeso_$index',
                            hintText: '0.0',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              final peso = double.tryParse(value);
                              if (peso == null || peso <= 0) {
                                return 'Número > 0';
                              }
                              final allValues =
                                  _formKey.currentState?.instantValue ?? {};
                              final valoresPesos = allValues.entries
                                  .where(
                                    (e) => e.key.startsWith('gaverasPeso_'),
                                  )
                                  .map(
                                    (e) => double.tryParse(e.value.toString()),
                                  )
                                  .whereType<double>()
                                  .toList();
                              if (valoresPesos.where((p) => p == peso).length >
                                  1) {
                                return 'Peso duplicado';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_gaveras.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 2),
                            child: InkWell(
                              key: Key(
                                'stage1-load-form-remove-gaveras-button$index',
                              ),
                              onTap: () => _removeGavera(index),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: AppColors.error,
                                  size: 22,
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Canastillas ──────────────────────────────────────
          SectionCard(
            iconColor: AppColors.register,
            icon: Icons.shopping_basket,
            title: 'Canastillas',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Cantidad de canastillas'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  key: const Key('stage1-load-form-baskets-quantity'),
                  name: 'basketsQuantity',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Este campo es obligatorio',
                    ),
                    FormBuilderValidators.integer(),
                    FormBuilderValidators.min(1),
                  ]),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Suministros ──────────────────────────────────────
          SectionCard(
            icon: Icons.science_rounded,
            title: 'Suministros',
            iconColor: AppColors.accepted,
            child: Column(
              children: [
                _SubSectionLabel(textTheme, 'Conservantes'),
                const SizedBox(height: AppSpacing.xSmall),
                TwoFormsRow(
                  nameFirst: 'preservativesJars',
                  labeFirst: 'Tarros',
                  nameSecond: 'preservativesWeight',
                  labeSecond: 'Peso (kg)',
                ),
                const SizedBox(height: AppSpacing.small),
                _SubSectionLabel(textTheme, 'Cal'),
                const SizedBox(height: AppSpacing.xSmall),
                TwoFormsRow(
                  nameFirst: 'limeJars',
                  labeFirst: 'Tarros',
                  nameSecond: 'limeWeight',
                  labeSecond: 'Peso (kg)',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Contacto ─────────────────────────────────────────
          SectionCard(
            icon: Icons.phone,
            iconColor: AppColors.weight,
            title: 'Contacto',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Teléfono'),
                const SizedBox(height: AppSpacing.xSmall),
                AppFormTextFild(
                  key: const Key('stage1-load-form-phone-input'),
                  name: 'phone',
                  hintText: '300 000 0000',
                  keyboardType: TextInputType.phone,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Este campo es obligatorio',
                    ),
                    FormBuilderValidators.numeric(errorText: 'Solo números'),
                    FormBuilderValidators.maxLength(10),
                    FormBuilderValidators.minLength(7),
                  ]),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Sección: Foto ─────────────────────────────────────────────
          SectionCard(
            iconColor: AppColors.error,
            icon: Icons.camera_alt,
            title: 'Registro fotográfico',
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    key: const Key('stage1-load-form-photo-button'),
                    onPressed: () => _onPickImage(textTheme),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      backgroundColor: AppColors.primaryPanelaBrown,
                    ),
                    icon: Icon(
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
                  GestureDetector(
                    key: const Key('stage1-load-form-image'),
                    onTap: () =>
                        context.push(Routes.imageViewer, extra: _photoPath),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: StageImageWidget(
                        imagePath: _photoPath!,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.medium),

          // ── Botón guardar ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('stage1-load-form-summit-button'),
              onPressed: isSubmitting ? null : () => _onSubmit(formNotifier),
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
                      'Guardar registro',
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

  Future<void> _onSubmit(Stage1Form formNotifier) async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    final values = _formKey.currentState!.value;
    final gaveras = <GaveraData>[];
    for (int i = 0; i < _gaveras.length; i++) {
      final cantidad = int.tryParse(values['gaverasCantidad_$i'] ?? '') ?? 0;
      final peso = double.tryParse(values['gaverasPeso_$i'] ?? '') ?? 0.0;
      gaveras.add(GaveraData(quantity: cantidad, referenceWeight: peso));
    }

    final data = Stage1FormData(
      id: widget.initialData?.id ?? _uuid.v4(),
      name: values['name'],
      gaveras: gaveras,
      basketsQuantity: int.parse(values['basketsQuantity']),
      preservativesWeight: double.parse(values['preservativesWeight']),
      preservativesJars: int.parse(values['preservativesJars']),
      limeWeight: double.parse(values['limeWeight']),
      limeJars: int.parse(values['limeJars']),
      phone: values['phone'],
      date: widget.initialData?.date ?? DateTime.now(),
      photoPath: _photoPath,
    );
    formNotifier.submit(data, isNew: widget.isNew);
  }

  void _onPickImage(TextTheme textTheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundCrema,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        title: Text('Seleccionar imagen', style: textTheme.headlineMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ImageSourceTile(
              key: const Key('stage1-load-form-camera-button'),
              icon: Icons.camera_alt,
              label: 'Cámara',
              onTap: () {
                Navigator.of(context).pop();
                _pickFromCamera();
              },
            ),
            const SizedBox(height: AppSpacing.xSmall),
            _ImageSourceTile(
              icon: Icons.photo_library_outlined,
              label: 'Galería',
              onTap: () {
                Navigator.of(context).pop();
                _pickFromGallery();
              },
            ),
          ],
        ),
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
      if (compressed != null) setState(() => _photoPath = compressed);
    }
  }

  Future<void> _pickFromGallery() async {
    final path = await ref
        .read(imagePickerServiceProvider)
        .pickImage(fromCamera: false);
    if (path != null) {
      final compressed = await compressFile(path);
      if (compressed != null) setState(() => _photoPath = compressed);
    }
  }
}

class _SubSectionLabel extends StatelessWidget {
  final TextTheme textTheme;
  final String label;

  const _SubSectionLabel(this.textTheme, this.label);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.accentLightPanela,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textDark.withAlpha(180),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 18, color: AppColors.primaryPanelaBrown),
            const SizedBox(width: 4),
            Text(
              'Agregar',
              style: TextStyle(
                fontSize: AppTypography.h4,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPanelaBrown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageSourceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImageSourceTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.xSmall,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.secondaryDarkPanela.withAlpha(60),
          ),
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPanelaBrown, size: 24),
            const SizedBox(width: AppSpacing.xSmall),
            Text(label, style: textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
