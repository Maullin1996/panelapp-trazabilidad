import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/core/services/image_picker_service_provider.dart';
import 'package:registro_panela/features/inventory/domain/entities/inventory_item.dart';
import 'package:registro_panela/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:registro_panela/features/molienda/domain/entities/molienda.dart';
import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_form_provider.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

class Stage1LoadForm extends ConsumerStatefulWidget {
  final Stage1FormData? initialData;
  final bool isNew;
  const Stage1LoadForm({required this.isNew, this.initialData, super.key});

  @override
  ConsumerState<Stage1LoadForm> createState() => _Stage1LoadFormState();
}

class _Stage1LoadFormState extends ConsumerState<Stage1LoadForm> {
  late final GlobalKey<FormBuilderState> _formKey;
  late final List<int> _gaveras;
  late final List<int> _baskets;
  bool _initialized = false;
  late final Uuid _uuid;
  Uint8List? _photoBytes;

  final Map<int, InventoryItem> _selectedGaveraItems = {};
  Molienda? _selectedMolienda;
  bool _moliendaInitialized = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormBuilderState>();
    _gaveras = widget.initialData?.gaveras.asMap().keys.toList() ?? [0];
    _baskets = widget.initialData?.baskets.asMap().keys.toList() ?? [0];
    _uuid = const Uuid();
  }

  void _addGavera() => setState(() => _gaveras.add(_gaveras.length));

  void _removeGavera(int index) {
    setState(() {
      _gaveras.remove(index);
      _selectedGaveraItems.remove(index);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized || widget.initialData == null) return;

    final inventoryItems = ref.read(syncInventoryItemsProvider);
    if (inventoryItems.isEmpty) return;

    _initialized = true;

    for (int i = 0; i < widget.initialData!.gaveras.length; i++) {
      final gavera = widget.initialData!.gaveras[i];
      final match = inventoryItems.firstWhereOrNull(
        (item) =>
            item.type == InventoryItemType.gavera &&
            (item.referenceWeight! - gavera.referenceWeight).abs() < 0.001 &&
            item.gaveraType == gavera.gaveraType,
      );
      if (match != null) {
        _selectedGaveraItems[i] = match;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.fields['gaveraItem_$i']?.didChange(match);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final initial = widget.initialData;
    final status = ref.watch(stage1FormProvider.select((s) => s.status));
    final formNotifier = ref.read(stage1FormProvider.notifier);
    final textTheme = TextTheme.of(context);
    final isSubmitting = status == Stage1FormStatus.submitting;

    final inventoryItems = ref.watch(syncInventoryItemsProvider);
    final moliendasDisponibles = ref.watch(syncMoliendaItemsProvider);
    final gaverasInventario = inventoryItems
        .where((i) => i.type == InventoryItemType.gavera)
        .toList();
    final canastillasInventario = inventoryItems
        .where((i) => i.type == InventoryItemType.canastilla)
        .toList();

    if (!_initialized &&
        gaverasInventario.isNotEmpty &&
        widget.initialData != null) {
      didChangeDependencies();
    }

    if (!_moliendaInitialized &&
        widget.initialData?.moliendaId != null &&
        moliendasDisponibles.isNotEmpty) {
      final match = moliendasDisponibles.firstWhereOrNull(
        (m) => m.id == widget.initialData!.moliendaId,
      );
      if (match != null) {
        _moliendaInitialized = true;
        _selectedMolienda = match;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.fields['molienda']?.didChange(match);
        });
      }
    }

    return FormBuilder(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: initial == null
          ? {}
          : {
              'molienda': _selectedMolienda,
              for (var i = 0; i < initial.baskets.length; i++)
                'basketsCantidad_$i': initial.baskets[i].quantity.toString(),
              for (var i = 0; i < initial.baskets.length; i++)
                'basketsTipo_$i': initial.baskets[i].size,
              'preservativesWeight': initial.preservativesWeight.toString(),
              'preservativesJars': initial.preservativesJars.toString(),
              'limeWeight': initial.limeWeight.toString(),
              'limeJars': initial.limeJars.toString(),
              for (int i = 0; i < initial.gaveras.length; i++)
                'gaverasCantidad_$i': initial.gaveras[i].quantity.toString(),
              for (int i = 0; i < initial.gaveras.length; i++)
                'gaveraItem_$i': _selectedGaveraItems[i],
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Información general ──────────────────────────────────────
          SectionCard(
            icon: Icons.storefront_outlined,
            iconColor: AppColors.primaryPanelaBrown,
            title: 'Información general',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FieldLabel(textTheme, 'Nombre molienda'),
                const SizedBox(height: AppSpacing.xSmall),
                CustomFromDropdown<Molienda>(
                  key: const Key('stage1-load-form-molienda-dropdown'),
                  name: 'molienda',
                  items: moliendasDisponibles
                      .map(
                        (m) => DropdownMenuItem<Molienda>(
                          key: Key('molienda_item_${m.id}'),
                          value: m,
                          child: Text(m.nombre, style: textTheme.bodyLarge),
                        ),
                      )
                      .toList(),
                  onChanged: (m) => setState(() => _selectedMolienda = m),
                  validator: FormBuilderValidators.required(
                    errorText: 'Este campo es obligatorio',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Gaveras ──────────────────────────────────────────────────
          SectionCard(
            icon: Icons.storage,
            iconColor: AppColors.weight,
            title: 'Gaveras',
            trailing: _AddButton(
              key: const Key('stage1-load-form-add-gaveras-button'),
              onTap: _addGavera,
            ),
            child: gaverasInventario.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.small,
                    ),
                    child: Center(
                      child: Text(
                        'No hay gaveras en el inventario',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textDark.withAlpha(120),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: _gaveras.map((index) {
                      return Column(
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
                          _GaveraRow(
                            index: index,
                            showRemove: _gaveras.length > 1,
                            gaverasInventario: gaverasInventario,
                            textTheme: textTheme,
                            selectedItem: _selectedGaveraItems[index],
                            onRemove: () => _removeGavera(index),
                            onItemSelected: (item) => setState(
                              () => _selectedGaveraItems[index] = item,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xSmall),
                        ],
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Canastillas ──────────────────────────────────────────────
          SectionCard(
            iconColor: AppColors.register,
            icon: Icons.shopping_basket,
            title: 'Canastillas',
            trailing: _AddButton(
              key: const Key('stage1-load-form-add-baskets-button'),
              onTap: () => setState(() => _baskets.add(_baskets.length)),
            ),
            child: canastillasInventario.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.small,
                    ),
                    child: Center(
                      child: Text(
                        'No hay canastillas en el inventario',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textDark.withAlpha(120),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: _baskets.map((index) {
                      return Column(
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
                          _BasketRow(
                            index: index,
                            showRemove: _baskets.length > 1,
                            textTheme: textTheme,
                            canastillasInventario: canastillasInventario,
                            onRemove: () =>
                                setState(() => _baskets.remove(index)),
                          ),
                          const SizedBox(height: AppSpacing.xSmall),
                        ],
                      );
                    }).toList(),
                  ),
          ),

          const SizedBox(height: AppSpacing.small),

          // ── Suministros ──────────────────────────────────────────────
          SectionCard(
            icon: Icons.science_rounded,
            title: 'Suministros',
            iconColor: AppColors.accepted,
            child: Column(
              children: [
                _SubLabel(textTheme, 'Conservantes'),
                const SizedBox(height: AppSpacing.xSmall),
                _TwoFieldsRow(
                  nameFirst: 'preservativesJars',
                  labelFirst: 'Tarros',
                  nameSecond: 'preservativesWeight',
                  labelSecond: 'Peso (kg)',
                  textTheme: textTheme,
                ),
                const SizedBox(height: AppSpacing.small),
                _SubLabel(textTheme, 'Cal'),
                const SizedBox(height: AppSpacing.xSmall),
                _TwoFieldsRow(
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

          // ── Foto ─────────────────────────────────────────────────────
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
                    onPressed: _onPickImage,
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
      final selectedItem = _selectedGaveraItems[_gaveras[i]];
      if (selectedItem == null) continue;
      final cantidad =
          int.tryParse(values['gaverasCantidad_${_gaveras[i]}'] ?? '') ?? 0;
      gaveras.add(
        GaveraData(
          quantity: cantidad,
          referenceWeight: selectedItem.referenceWeight!,
          gaveraType: selectedItem.gaveraType ?? '',
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
      name: _selectedMolienda!.nombre,
      moliendaId: _selectedMolienda!.id,
      baskets: baskets,
      gaveras: gaveras,
      preservativesWeight: double.parse(values['preservativesWeight']),
      preservativesJars: int.parse(values['preservativesJars']),
      limeWeight: double.parse(values['limeWeight']),
      limeJars: int.parse(values['limeJars']),
      phone: _selectedMolienda!.telefono,
      date: widget.initialData?.date ?? DateTime.now(),
      photoPath: widget.initialData?.photoPath,
    );
    formNotifier.submit(
      data,
      isNew: widget.isNew,
      photoBytes: _photoBytes,
      previousData: widget.initialData,
    );
  }

  Future<void> _onPickImage() async {
    final bytes = await ref.read(imagePickerServiceProvider).pickImage();
    if (bytes != null) setState(() => _photoBytes = bytes);
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _GaveraRow extends StatelessWidget {
  final int index;
  final bool showRemove;
  final List<InventoryItem> gaverasInventario;
  final TextTheme textTheme;
  final InventoryItem? selectedItem;
  final VoidCallback onRemove;
  final ValueChanged<InventoryItem> onItemSelected;

  const _GaveraRow({
    required this.index,
    required this.showRemove,
    required this.gaverasInventario,
    required this.textTheme,
    required this.selectedItem,
    required this.onRemove,
    required this.onItemSelected,
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gavera (peso — tipo)', style: textTheme.bodySmall),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomFromDropdown<InventoryItem>(
                    key: Key('stage1-load-form-gavera-item-$index'),
                    name: 'gaveraItem_$index',
                    items: gaverasInventario
                        .map(
                          (item) => DropdownMenuItem<InventoryItem>(
                            key: Key('gavera_item_${item.id}'),
                            value: item,
                            child: Text(
                              '${item.referenceWeight} g — ${item.gaveraType ?? ''}  (disp: ${item.availableUnits})',
                              style: textTheme.bodyLarge,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (item) {
                      if (item != null) onItemSelected(item);
                    },
                    validator: FormBuilderValidators.required(
                      errorText: 'Requerido',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
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
            if (showRemove)
              Padding(
                padding: const EdgeInsets.only(top: 22),
                child: IconButton(
                  key: Key('stage1-load-form-remove-gaveras-button$index'),
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.error,
                  ),
                ),
              )
            else
              const SizedBox(width: 40),
          ],
        ),
        if (selectedItem != null) ...[
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.weight.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Tipo: ${selectedItem!.gaveraType ?? ''}',
              style: TextStyle(
                fontSize: AppTypography.h5,
                fontWeight: FontWeight.w600,
                color: AppColors.weight,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
        ],
      ],
    );
  }
}

class _BasketRow extends StatelessWidget {
  final int index;
  final bool showRemove;
  final TextTheme textTheme;
  final List<InventoryItem> canastillasInventario;
  final VoidCallback onRemove;

  const _BasketRow({
    required this.index,
    required this.showRemove,
    required this.textTheme,
    required this.canastillasInventario,
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
                items: BasketSize.values.map((s) {
                  final inventoryItem = canastillasInventario.firstWhereOrNull(
                    (i) => i.size == s,
                  );
                  final disponibles = inventoryItem?.availableUnits;
                  return DropdownMenuItem<BasketSize>(
                    key: Key('basket_size_${s.name}'),
                    value: s,
                    child: Text(
                      disponibles != null
                          ? '${s.label}  (disp: $disponibles)'
                          : s.label,
                      style: textTheme.bodyLarge,
                    ),
                  );
                }).toList(),
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
              key: Key('stage1-load-form-remove-basket-button$index'),
              onPressed: onRemove,
              icon: const Icon(
                Icons.remove_circle_outline,
                color: AppColors.error,
              ),
            ),
          )
        else
          const SizedBox(width: 40),
      ],
    );
  }
}

class _TwoFieldsRow extends StatelessWidget {
  final String nameFirst;
  final String labelFirst;
  final String nameSecond;
  final String labelSecond;
  final TextTheme textTheme;

  const _TwoFieldsRow({
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
                key: Key('stage1-load-form-$nameFirst-input'),
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
                key: Key('stage1-load-form-$nameSecond-input'),
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
