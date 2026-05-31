import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import 'package:core/features/inventory/domain/entities/inventory_item.dart';
import 'package:core/features/inventory/providers/inventory_providers.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/core/services/custom_snack_bar.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(inventoryFormProvider, (_, next) {
      if (next.status == InventoryFormStatus.success) {
        CustomSnackBar.show(
          context,
          message: 'Guardado correctamente',
          status: SnackbarStatus.accepted,
        );
      } else if (next.status == InventoryFormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    final itemsAsync = ref.watch(inventoryItemsProvider);
    final textTheme = TextTheme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Inventario', style: textTheme.headlineMedium),
      ),
      body: itemsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPanelaBrown),
        ),
        error: (e, _) => ErrorWidgetCustom(error: e.toString()),
        data: (items) {
          final gaveras = items
              .where((i) => i.type == InventoryItemType.gavera)
              .toList();
          final canastillas = items
              .where((i) => i.type == InventoryItemType.canastilla)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
            children: [
              // ── Gaveras ──────────────────────────────────────────
              _SectionHeader(
                title: 'Gaveras',
                icon: Icons.storage_rounded,
                iconColor: AppColors.weight,
                onAdd: () => _showItemDialog(
                  context,
                  ref,
                  type: InventoryItemType.gavera,
                ),
              ),
              const SizedBox(height: 8),
              if (gaveras.isEmpty)
                const _EmptySection(message: 'Sin gaveras registradas')
              else
                ...gaveras.map(
                  (item) => _InventoryCard(
                    item: item,
                    onEdit: () => _showItemDialog(
                      context,
                      ref,
                      type: InventoryItemType.gavera,
                      item: item,
                    ),
                    onDelete: () => _confirmDelete(context, ref, item.id),
                  ),
                ),

              const SizedBox(height: 20),

              // ── Canastillas ──────────���────────────────────────────
              _SectionHeader(
                title: 'Canastillas',
                icon: Icons.shopping_basket,
                iconColor: AppColors.register,
                onAdd: () => _showItemDialog(
                  context,
                  ref,
                  type: InventoryItemType.canastilla,
                ),
              ),
              const SizedBox(height: 8),
              if (canastillas.isEmpty)
                const _EmptySection(message: 'Sin canastillas registradas')
              else
                ...canastillas.map(
                  (item) => _InventoryCard(
                    item: item,
                    onEdit: () => _showItemDialog(
                      context,
                      ref,
                      type: InventoryItemType.canastilla,
                      item: item,
                    ),
                    onDelete: () => _confirmDelete(context, ref, item.id),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showItemDialog(
    BuildContext context,
    WidgetRef ref, {
    required InventoryItemType type,
    InventoryItem? item,
  }) {
    showDialog(
      context: context,
      builder: (_) =>
          _InventoryFormDialog(type: type, item: item, isNew: item == null),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
  ) async {
    final textTheme = TextTheme.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('¿Eliminar item?', style: textTheme.headlineLarge),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancelar', style: textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(inventoryFormProvider.notifier).delete(id);
    }
  }
}

// ── Section Header ──────��────────────────────────────��─────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onAdd;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(AppRadius.small),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
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
        ),
      ],
    );
  }
}

// ── Inventory Card ──────────────────────���──────────────────────────────��───────
class _InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _InventoryCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final isGavera = item.type == InventoryItemType.gavera;
    final accentColor = isGavera ? AppColors.weight : AppColors.register;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.small),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isGavera ? Icons.storage_rounded : Icons.shopping_basket,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGavera
                          ? '${item.referenceWeight} g — ${item.gaveraType ?? ''}'
                          : item.size?.label ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _StatBadge(
                          label: 'Total',
                          value: '${item.totalUnits}',
                          color: AppColors.textDark,
                        ),
                        _StatBadge(
                          label: 'Disponible',
                          value: '${item.availableUnits}',
                          color: item.availableUnits > 0
                              ? AppColors.accepted
                              : AppColors.error,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryPanelaBrown,
                  size: 20,
                ),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 20,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: AppTypography.h5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _EmptySection extends StatelessWidget {
  final String message;
  const _EmptySection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            color: AppColors.textDark.withAlpha(120),
            fontSize: AppTypography.body,
          ),
        ),
      ),
    );
  }
}

// ── Form Dialog ──────────���─────────────────────────────────────────────────────
class _InventoryFormDialog extends ConsumerStatefulWidget {
  final InventoryItemType type;
  final InventoryItem? item;
  final bool isNew;

  const _InventoryFormDialog({
    required this.type,
    this.item,
    required this.isNew,
  });

  @override
  ConsumerState<_InventoryFormDialog> createState() =>
      _InventoryFormDialogState();
}

class _InventoryFormDialogState extends ConsumerState<_InventoryFormDialog> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final isGavera = widget.type == InventoryItemType.gavera;
    final formState = ref.watch(inventoryFormProvider);
    final isSubmitting = formState.status == InventoryFormStatus.submitting;
    final item = widget.item;

    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      title: Text(
        widget.isNew
            ? 'Agregar ${isGavera ? 'gavera' : 'canastilla'}'
            : 'Editar ${isGavera ? 'gavera' : 'canastilla'}',
        style: textTheme.headlineMedium,
      ),
      content: FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: item == null
            ? {}
            : {
                if (isGavera) ...{
                  'referenceWeight': item.referenceWeight?.toString() ?? '',
                  'gaveraType': item.gaveraType,
                },
                if (!isGavera) 'size': item.size,
                'totalUnits': item.totalUnits.toString(),
              },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isGavera) ...[
              FieldLabel(textTheme, 'Peso de referencia (g)'),
              const SizedBox(height: AppSpacing.xSmall),
              AppFormTextFild(
                name: 'referenceWeight',
                hintText: 'Ej. 500.0',
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: 'Requerido'),
                  FormBuilderValidators.numeric(errorText: 'Solo números'),
                ]),
              ),
              const SizedBox(height: AppSpacing.small),
              FieldLabel(textTheme, 'Tipo (texto libre)'),
              const SizedBox(height: AppSpacing.xSmall),
              AppFormTextFild(
                name: 'gaveraType',
                hintText: 'Ej. Kilo, Redonda, Pastilla...',
                validator: FormBuilderValidators.required(
                  errorText: 'Requerido',
                ),
              ),
              const SizedBox(height: AppSpacing.small),
            ] else ...[
              FieldLabel(textTheme, 'Tamaño'),
              const SizedBox(height: AppSpacing.xSmall),
              CustomFromDropdown<BasketSize>(
                name: 'size',
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
              const SizedBox(height: AppSpacing.small),
            ],
            FieldLabel(textTheme, 'Total unidades'),
            const SizedBox(height: AppSpacing.xSmall),
            AppFormTextFild(
              name: 'totalUnits',
              hintText: '0',
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Requerido'),
                FormBuilderValidators.integer(errorText: 'Solo enteros'),
                FormBuilderValidators.min(1),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar', style: textTheme.bodyLarge),
        ),
        ElevatedButton(
          onPressed: isSubmitting ? null : _onSubmit,
          child: isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.cardBackground,
                  ),
                )
              : Text(
                  'Guardar',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.cardBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _onSubmit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) return;
    final values = _formKey.currentState!.value;
    final isGavera = widget.type == InventoryItemType.gavera;
    final totalUnits = int.parse(values['totalUnits']);
    final isNew = widget.isNew;

    final item = InventoryItem(
      id: widget.item?.id ?? const Uuid().v4(),
      type: widget.type,
      totalUnits: totalUnits,
      availableUnits: isNew
          ? totalUnits
          : (widget.item!.availableUnits +
                    (totalUnits - widget.item!.totalUnits))
                .clamp(0, totalUnits),
      referenceWeight: isGavera
          ? double.parse(values['referenceWeight'])
          : null,
      gaveraType: isGavera ? values['gaveraType'] as String : null,
      size: !isGavera ? values['size'] as BasketSize : null,
    );

    await ref.read(inventoryFormProvider.notifier).save(item, isNew: isNew);

    if (mounted) Navigator.of(context).pop();
  }
}
