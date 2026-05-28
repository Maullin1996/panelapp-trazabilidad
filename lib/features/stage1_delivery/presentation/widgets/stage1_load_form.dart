import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_enums_labels.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/widgets/two_form_row.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_form_provider.dart';
import 'package:registro_panela/shared/widgets/field_label.dart';
import 'package:registro_panela/shared/widgets/section_card.dart';
import 'package:registro_panela/shared/widgets/selection_source_title.dart';
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
  late final List<int> _baskets;
  late final Uuid _uuid;
  Uint8List? _photoBytes;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
    _gaveras = widget.initialData?.gaveras.asMap().keys.toList() ?? [0];
    _baskets = widget.initialData?.baskets.asMap().keys.toList() ?? [0];
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
              ...{
                for (var i = 0; i < initial.baskets.length; i++)
                  'basketsCantidad_$i': initial.baskets[i].quantity.toString(),
                for (var i = 0; i < initial.baskets.length; i++)
                  'basketsTipo_$i': initial.baskets[i].size,
              },
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
                for (var i = 0; i < initial.gaveras.length; i++)
                  'gaverasTipo_$i': initial.gaveras[i].gaveraType,
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
                ..._gaveras.map(
                  (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != _gaveras.first)
                        const Divider(height: AppSpacing.medium),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.xSmall,
                        ),
                        child: Text(
                          'Gavera ${_gaveras.indexOf(index) + 1}',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryPanelaBrown,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      _GaveraItem(
                        index: index,
                        showRemove: _gaveras.length > 1,
                        gaveraTypes: GaveraType.values,
                        textTheme: textTheme,
                        formKey: _formKey,
                        onRemove: () => _removeGavera(index),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                    ],
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
            trailing: _AddButton(
              key: const Key('stage1-load-form-add-baskets-button'),
              onTap: () => setState(() => _baskets.add(_baskets.length)),
            ),
            child: Column(
              children: [
                ..._baskets.map(
                  (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index != _baskets.first)
                        const Divider(height: AppSpacing.medium),
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.xSmall,
                        ),
                        child: Text(
                          'Canastilla ${_baskets.indexOf(index) + 1}',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.register,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      _BasketItem(
                        index: index,
                        showRemove: _baskets.length > 1,
                        textTheme: textTheme,
                        onRemove: () => setState(() => _baskets.remove(index)),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                    ],
                  ),
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
                      _photoBytes == null ? 'Tomar foto' : 'Cambiar foto',
                      style: textTheme.headlineSmall?.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_photoBytes != null ||
                    widget.initialData?.photoPath != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  GestureDetector(
                    key: const Key('stage1-load-form-image'),
                    onTap: () {
                      final url = widget.initialData?.photoPath;
                      if (url != null) {
                        context.push(Routes.imageViewer, extra: url);
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      child: StageImageWidget(
                        imageBytes: _photoBytes,
                        imageUrl: _photoBytes == null
                            ? widget.initialData?.photoPath
                            : null,
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
    final baskets = <BasketData>[];
    for (int i = 0; i < _gaveras.length; i++) {
      final cantidad = int.tryParse(values['gaverasCantidad_$i'] ?? '') ?? 0;
      final peso = double.tryParse(values['gaverasPeso_$i'] ?? '') ?? 0.0;
      final tipo = values['gaverasTipo_$i'] as GaveraType;
      gaveras.add(
        GaveraData(quantity: cantidad, referenceWeight: peso, gaveraType: tipo),
      );
    }

    for (int i = 0; i < _baskets.length; i++) {
      final cantidad = int.tryParse(values['basketsCantidad_$i'] ?? '') ?? 0;
      final size = values['basketsTipo_$i'] as BasketSize;
      baskets.add(BasketData(size: size, quantity: cantidad));
    }

    final data = Stage1FormData(
      id: widget.initialData?.id ?? _uuid.v4(),
      name: values['name'],
      baskets: baskets,
      gaveras: gaveras,
      preservativesWeight: double.parse(values['preservativesWeight']),
      preservativesJars: int.parse(values['preservativesJars']),
      limeWeight: double.parse(values['limeWeight']),
      limeJars: int.parse(values['limeJars']),
      phone: values['phone'],
      date: widget.initialData?.date ?? DateTime.now(),
      photoPath:
          widget.initialData?.photoPath, // URL existente o null si es nuevo
    );
    formNotifier.submit(data, isNew: widget.isNew, photoBytes: _photoBytes);
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
            SelectionSourceTile(
              key: const Key('stage1-load-form-camera-button'),
              icon: Icons.camera_alt,
              label: 'Cámara',
              onTap: () {
                Navigator.of(context).pop();
                _pickFromCamera();
              },
            ),
            const SizedBox(height: AppSpacing.xSmall),
            SelectionSourceTile(
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
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromCamera(context);
    if (bytes != null) setState(() => _photoBytes = bytes);
  }

  Future<void> _pickFromGallery() async {
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromGallery();
    if (bytes != null) setState(() => _photoBytes = bytes);
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

class _GaveraItem extends StatelessWidget {
  final int index;
  final bool showRemove;
  final List<GaveraType> gaveraTypes;
  final TextTheme textTheme;
  final GlobalKey<FormBuilderState> formKey;
  final VoidCallback onRemove;

  const _GaveraItem({
    required this.index,
    required this.showRemove,
    required this.gaveraTypes,
    required this.textTheme,
    required this.formKey,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1: Cantidad + Peso + botón eliminar
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _LabeledField(
                label: 'Cantidad',
                textTheme: textTheme,
                child: AppFormTextFild(
                  name: 'gaverasCantidad_$index',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(errorText: 'Requerido'),
                    FormBuilderValidators.integer(errorText: 'Solo números'),
                    FormBuilderValidators.min(1),
                  ]),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Expanded(
              child: _LabeledField(
                label: 'Peso (g)',
                textTheme: textTheme,
                child: AppFormTextFild(
                  name: 'gaverasPeso_$index',
                  hintText: '0.0',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Requerido';
                    final peso = double.tryParse(value);
                    if (peso == null || peso <= 0) return 'Número > 0';
                    final allValues = formKey.currentState?.instantValue ?? {};
                    final valoresPesos = allValues.entries
                        .where((e) => e.key.startsWith('gaverasPeso_'))
                        .map((e) => double.tryParse(e.value.toString()))
                        .whereType<double>()
                        .toList();
                    if (valoresPesos.where((p) => p == peso).length > 1) {
                      return 'Peso duplicado';
                    }
                    return null;
                  },
                ),
              ),
            ),
            if (showRemove)
              Padding(
                padding: const EdgeInsets.only(left: 4, top: 22),
                child: InkWell(
                  key: Key('stage1-load-form-remove-gaveras-button$index'),
                  onTap: onRemove,
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
        const SizedBox(height: AppSpacing.xSmall),

        // Fila 2: Tipo
        Row(
          children: [
            Expanded(
              child: _LabeledField(
                label: 'Tipo',
                textTheme: textTheme,
                child: CustomFromDropdown<GaveraType>(
                  key: Key('stage1-load-form-gavera-tipo-$index'),
                  name: 'gaverasTipo_$index',
                  items: gaveraTypes
                      .map(
                        (g) => DropdownMenuItem<GaveraType>(
                          key: Key('gavera_de_tipo_${g.name}'),
                          value: g,
                          child: Text(g.label, style: textTheme.bodyLarge),
                        ),
                      )
                      .toList(),
                  validator: FormBuilderValidators.required(
                    errorText: 'Requerido',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 40),
          ],
        ),
      ],
    );
  }
}

// Widget auxiliar para no repetir el patrón label + SizedBox + field
class _LabeledField extends StatelessWidget {
  final String label;
  final TextTheme textTheme;
  final Widget child;

  const _LabeledField({
    required this.label,
    required this.textTheme,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textDark.withAlpha(140),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: AppSpacing.xSmall),
        child,
      ],
    );
  }
}

class _BasketItem extends StatelessWidget {
  final int index;
  final bool showRemove;
  final TextTheme textTheme;
  final VoidCallback onRemove;

  const _BasketItem({
    required this.index,
    required this.showRemove,
    required this.textTheme,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _LabeledField(
            label: 'Cantidad',
            textTheme: textTheme,
            child: AppFormTextFild(
              name: 'basketsCantidad_$index',
              hintText: '0',
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Requerido'),
                FormBuilderValidators.integer(errorText: 'Solo números'),
                FormBuilderValidators.min(1),
              ]),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xSmall),
        Expanded(
          child: _LabeledField(
            label: 'Tamaño',
            textTheme: textTheme,
            child: CustomFromDropdown<BasketSize>(
              key: Key('stage1-load-form-basket-tipo-$index'),
              name: 'basketsTipo_$index',
              items: BasketSize.values
                  .map(
                    (s) => DropdownMenuItem<BasketSize>(
                      key: Key('basket_size_${s.name}'),
                      value: s,
                      child: Text(s.label, style: textTheme.bodyLarge),
                    ),
                  )
                  .toList(),
              validator: FormBuilderValidators.required(errorText: 'Requerido'),
            ),
          ),
        ),
        if (showRemove)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 22),
            child: InkWell(
              key: Key('stage1-load-form-remove-basket-button$index'),
              onTap: onRemove,
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
    );
  }
}
