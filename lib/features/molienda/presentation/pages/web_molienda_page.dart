import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/features/auth/domain/enums/user_role.dart';
import 'package:registro_panela/features/auth/presentation/providers/auth_provider.dart';
import 'package:registro_panela/features/molienda/domain/entities/molienda.dart';
import 'package:registro_panela/features/molienda/presentation/providers/molienda_providers.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import 'package:registro_panela/core/services/custom_snack_bar.dart';
import 'molienda_entregas_list.dart';
import 'molienda_form_dialog.dart';

class WebMoliendaPage extends ConsumerWidget {
  const WebMoliendaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(moliendaFormProvider, (_, next) {
      if (next.status == MoliendaFormStatus.success) {
        CustomSnackBar.show(
          context,
          message: 'Guardado correctamente',
          status: SnackbarStatus.accepted,
        );
      } else if (next.status == MoliendaFormStatus.error) {
        CustomSnackBar.show(
          context,
          message: 'Error al guardar',
          status: SnackbarStatus.error,
        );
      }
    });

    final itemsAsync = ref.watch(moliendaItemsProvider);
    final isAdmin = ref.watch(authProvider).user?.role == UserRole.admin;
    final textTheme = TextTheme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Moliendas', style: textTheme.headlineMedium),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.medium),
            child: ElevatedButton.icon(
              onPressed: () => _showFormDialog(context, ref),
              icon: const Icon(
                Icons.add,
                color: AppColors.cardBackground,
                size: 18,
              ),
              label: Text(
                'Agregar',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.cardBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryPanelaBrown),
        ),
        error: (e, _) => ErrorWidgetCustom(error: e.toString()),
        data: (moliendas) => moliendas.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: EmptyWidget(
                  message: 'Todavía no has creado ninguna molienda.',
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final cols = w < 600
                        ? 1
                        : w < 1000
                        ? 2
                        : 3;
                    final cardWidth =
                        (w - AppSpacing.xSmall * (cols - 1)) / cols;
                    return Wrap(
                      spacing: AppSpacing.medium,
                      runSpacing: AppSpacing.medium,
                      children: moliendas.map((m) {
                        return SizedBox(
                          width: cardWidth,
                          child: _MoliendaCard(
                            molienda: m,
                            onVerEntregas: () =>
                                _showEntregasDialog(context, m),
                            onEdit: () =>
                                _showFormDialog(context, ref, molienda: m),
                            onDelete: isAdmin
                                ? () => _confirmDelete(context, ref, m.id)
                                : null,
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
      ),
    );
  }

  void _showFormDialog(
    BuildContext context,
    WidgetRef ref, {
    Molienda? molienda,
  }) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.cardBackground,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.large),
          ),
        ),
        builder: (ctx) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: MoliendaFormDialog(
              molienda: molienda,
              isNew: molienda == null,
            ),
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: MoliendaFormDialog(
                molienda: molienda,
                isNew: molienda == null,
              ),
            ),
          ),
        ),
      );
    }
  }

  void _showEntregasDialog(BuildContext context, Molienda molienda) {
    final textTheme = TextTheme.of(context);
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480, maxHeight: 480),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Entregas de ${molienda.nombre}',
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.small),
                Expanded(child: MoliendaEntregasList(moliendaId: molienda.id)),
              ],
            ),
          ),
        ),
      ),
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
        title: Text('¿Eliminar molienda?', style: textTheme.headlineLarge),
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
      await ref.read(moliendaFormProvider.notifier).delete(id);
    }
  }
}

// ─── Tarjeta de molienda ──────────────────────────────────────────────────────

class _MoliendaCard extends StatelessWidget {
  final Molienda molienda;
  final VoidCallback onVerEntregas;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;

  const _MoliendaCard({
    required this.molienda,
    required this.onVerEntregas,
    required this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.storefront_outlined,
                  iconColor: AppColors.primaryPanelaBrown,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    molienda.nombre,
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.secondaryDarkPanela,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.local_shipping_outlined,
                    color: AppColors.weight,
                    size: 20,
                  ),
                  tooltip: 'Ver entregas',
                  onPressed: onVerEntregas,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryPanelaBrown,
                    size: 20,
                  ),
                  tooltip: 'Editar',
                  onPressed: onEdit,
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.error,
                      size: 20,
                    ),
                    tooltip: 'Eliminar',
                    onPressed: onDelete,
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.small,
              vertical: AppSpacing.xSmall,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.secondaryDarkPanela.withAlpha(45),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              bottom: AppSpacing.small,
            ),
            child: Column(
              children: [
                CustomRichText(
                  icon: Icons.phone,
                  iconColor: AppColors.weight,
                  firstText: 'Teléfono: ',
                  secondText: molienda.telefono,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.calendar_month,
                  iconColor: AppColors.secondaryDarkPanela,
                  firstText: 'Creada: ',
                  secondText: DateFormat(
                    'dd/MM/yyyy',
                  ).format(molienda.creadoEn),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
