import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:uuid/uuid.dart';

import 'package:core/core/services/image_picker_service_provider.dart';
import 'package:core/features/stage1_delivery/domain/entities/index.dart';
import 'package:core/features/stage1_delivery/providers/stage1_form_provider.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class WebStage1Form extends ConsumerStatefulWidget {
  final Stage1FormData? initialData;
  final bool isNew;
  const WebStage1Form({required this.isNew, this.initialData, super.key});

  @override
  ConsumerState<WebStage1Form> createState() => _WebStage1FormState();
}

class _WebStage1FormState extends ConsumerState<WebStage1Form> {
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
          // ── Información general ───────────────────────────────
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

          // ── Gaveras ───────────────────────────────────────────
          SectionCard(
            icon: Icons.storage,
            iconColor: AppColors.weight,
            title: 'Gaveras',
            trailing: _AddButton(onTap: _addGavera),
            child: Column(
              children: _gaveras
                  .map(
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
                            ),
                          ),
                        ),
                        _GaveraRow(
                          index: index,
                          showRemove: _gaveras.length > 1,
                          formKey: _formKey,
                          textTheme: textTheme,
                          onRemove: () => _removeGavera(index),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Canastillas ───────────────────────────────────────
          SectionCard(
            icon: Icons.shopping_basket,
            iconColor: AppColors.register,
            title: 'Canastillas',
            trailing: _AddButton(
              onTap: () => setState(() => _baskets.add(_baskets.length)),
            ),
            child: Column(
              children: _baskets
                  .map(
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
                            ),
                          ),
                        ),
                        _BasketRow(
                          index: index,
                          showRemove: _baskets.length > 1,
                          textTheme: textTheme,
                          onRemove: () =>
                              setState(() => _baskets.remove(index)),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Suministros ───────────────────────────────────────
          SectionCard(
            icon: Icons.science_rounded,
            title: 'Suministros',
            iconColor: AppColors.accepted,
            child: Column(
              children: [
                _SubLabel(textTheme, 'Conservantes'),
                const SizedBox(height: AppSpacing.xSmall),
                _TwoFields(
                  nameFirst: 'preservativesJars',
                  labelFirst: 'Tarros',
                  nameSecond: 'preservativesWeight',
                  labelSecond: 'Peso (kg)',
                  textTheme: textTheme,
                ),
                const SizedBox(height: AppSpacing.small),
                _SubLabel(textTheme, 'Cal'),
                const SizedBox(height: AppSpacing.xSmall),
                _TwoFields(
                  nameFirst: 'limeJars',
                  labelFirst: 'Tarros',
                  nameSecond: 'limeWeight',
                  labelSecond: 'Peso (kg)',
                  textTheme: textTheme,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Contacto ──────────────────────────────────────────
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

          // ── Foto ──────────────────────────────────────────────
          SectionCard(
            icon: Icons.camera_alt,
            iconColor: AppColors.error,
            title: 'Registro fotográfico',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickFromCamera(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.small,
                            ),
                          ),
                          backgroundColor: AppColors.primaryPanelaBrown,
                        ),
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.textLight,
                        ),
                        label: Text(
                          'Cámara',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _pickFromGallery(),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppRadius.small,
                            ),
                          ),
                          backgroundColor: AppColors.weight,
                        ),
                        icon: const Icon(
                          Icons.photo_library_outlined,
                          color: AppColors.textLight,
                        ),
                        label: Text(
                          'Galería',
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_photoBytes != null ||
                    widget.initialData?.photoPath != null) ...[
                  const SizedBox(height: AppSpacing.small),
                  ClipRRect(
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
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.medium),

          // ── Botón guardar ─────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
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
      gaveras.add(
        GaveraData(
          quantity: int.tryParse(values['gaverasCantidad_$i'] ?? '') ?? 0,
          referenceWeight:
              double.tryParse(values['gaverasPeso_$i'] ?? '') ?? 0.0,
          gaveraType: values['gaverasTipo_$i'] as GaveraType,
        ),
      );
    }

    for (int i = 0; i < _baskets.length; i++) {
      baskets.add(
        BasketData(
          quantity: int.tryParse(values['basketsCantidad_$i'] ?? '') ?? 0,
          size: values['basketsTipo_$i'] as BasketSize,
        ),
      );
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
      photoPath: widget.initialData?.photoPath,
    );

    formNotifier.submit(data, isNew: widget.isNew, photoBytes: _photoBytes);
  }

  Future<void> _pickFromGallery() async {
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromGallery();
    if (bytes != null) setState(() => _photoBytes = bytes);
  }

  Future<void> _pickFromCamera() async {
    final bytes = await ref
        .read(imagePickerServiceProvider)
        .captureFromCamera(context);
    if (bytes != null) setState(() => _photoBytes = bytes);
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

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

class _SubLabel extends StatelessWidget {
  final TextTheme textTheme;
  final String label;
  const _SubLabel(this.textTheme, this.label);

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

class _TwoFields extends StatelessWidget {
  final String nameFirst;
  final String labelFirst;
  final String nameSecond;
  final String labelSecond;
  final TextTheme textTheme;

  const _TwoFields({
    required this.nameFirst,
    required this.labelFirst,
    required this.nameSecond,
    required this.labelSecond,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labelFirst, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xSmall),
              AppFormTextFild(
                name: nameFirst,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio',
                  ),
                  FormBuilderValidators.numeric(
                    errorText: 'Debe ser un valor numérico',
                  ),
                  FormBuilderValidators.min(0),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(labelSecond, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xSmall),
              AppFormTextFild(
                name: nameSecond,
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio',
                  ),
                  FormBuilderValidators.numeric(
                    errorText: 'Debe ser un valor numérico',
                  ),
                  FormBuilderValidators.min(0),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GaveraRow extends StatelessWidget {
  final int index;
  final bool showRemove;
  final GlobalKey<FormBuilderState> formKey;
  final TextTheme textTheme;
  final VoidCallback onRemove;

  const _GaveraRow({
    required this.index,
    required this.showRemove,
    required this.formKey,
    required this.textTheme,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad', style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xSmall),
                  AppFormTextFild(
                    name: 'gaverasCantidad_$index',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(errorText: 'Requerido'),
                      FormBuilderValidators.integer(errorText: 'Solo números'),
                      FormBuilderValidators.min(1),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Peso (g)', style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xSmall),
                  AppFormTextFild(
                    name: 'gaverasPeso_$index',
                    hintText: '0.0',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Requerido';
                      final peso = double.tryParse(value);
                      if (peso == null || peso <= 0) return 'Número > 0';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tipo', style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomFromDropdown<GaveraType>(
                    name: 'gaverasTipo_$index',
                    items: GaveraType.values
                        .map(
                          (g) => DropdownMenuItem(
                            value: g,
                            child: Text(g.label, style: textTheme.bodyLarge),
                          ),
                        )
                        .toList(),
                    validator: FormBuilderValidators.required(
                      errorText: 'Requerido',
                    ),
                  ),
                ],
              ),
            ),
            if (showRemove)
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.error,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BasketRow extends StatelessWidget {
  final int index;
  final bool showRemove;
  final TextTheme textTheme;
  final VoidCallback onRemove;

  const _BasketRow({
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cantidad', style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xSmall),
              AppFormTextFild(
                name: 'basketsCantidad_$index',
                hintText: '0',
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Requerido'),
                  FormBuilderValidators.integer(errorText: 'Solo números'),
                  FormBuilderValidators.min(1),
                ]),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tamaño', style: textTheme.bodySmall),
              const SizedBox(height: AppSpacing.xSmall),
              CustomFromDropdown<BasketSize>(
                name: 'basketsTipo_$index',
                items: BasketSize.values
                    .map(
                      (s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.label, style: textTheme.bodyLarge),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(
                  errorText: 'Requerido',
                ),
              ),
            ],
          ),
        ),
        if (showRemove)
          Padding(
            padding: const EdgeInsets.only(top: 22),
            child: IconButton(
              onPressed: onRemove,
              icon: const Icon(
                Icons.remove_circle_outline,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}
