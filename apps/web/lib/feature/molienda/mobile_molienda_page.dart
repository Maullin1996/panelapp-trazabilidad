import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/features/molienda/domain/entities/molienda.dart';
import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/core/services/custom_snack_bar.dart';
import 'molienda_form_dialog.dart';

class MobileMoliendaPage extends ConsumerWidget {
  const MobileMoliendaPage({super.key});

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
    final textTheme = TextTheme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Moliendas', style: textTheme.headlineMedium),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context, ref),
        shape: const CircleBorder(),
        backgroundColor: AppColors.primaryPanelaBrown,
        
        child: const Icon(Icons.add, color: AppColors.backgroundCrema),
      ),
      body: SafeArea(
        bottom: true,
        child: itemsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryPanelaBrown,
            ),
          ),
          error: (e, _) => ErrorWidgetCustom(error: e.toString()),
          data: (moliendas) => 
          moliendas.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: EmptyWidget(message: "Todavía no has creado ninguna molienda."  ))
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.small),
                  itemCount: moliendas.length,
                  itemBuilder: (context, index) => _MoliendaCard(
                    molienda: moliendas[index],
                    textTheme: textTheme,
                    onVerEntregas: () =>
                        _showEntregasDialog(context, moliendas[index]),
                    onEdit: () =>
                        _showFormDialog(context, ref, molienda: moliendas[index]),
                    onDelete: () =>
                        _confirmDelete(context, ref, moliendas[index].id),
                  ),
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
          child: MoliendaFormDialog(molienda: molienda, isNew: molienda == null),
        ),
      ),
    );
  }

  void _showEntregasDialog(BuildContext context, Molienda molienda) {
    final textTheme = TextTheme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (_) => SizedBox(
        height: 420,
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
              Expanded(child: _EntregasList(moliendaId: molienda.id)),
            ],
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

class _MoliendaCard extends StatelessWidget {
  final Molienda molienda;
  final TextTheme textTheme;
  final VoidCallback onVerEntregas;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MoliendaCard({
    required this.molienda,
    required this.textTheme,
    required this.onVerEntregas,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                  secondText: DateFormat('dd/MM/yyyy').format(
                    molienda.creadoEn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntregasList extends ConsumerWidget {
  final String moliendaId;
  const _EntregasList({required this.moliendaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final entregasAsync = ref.watch(moliendaEntregasProvider(moliendaId));

    return entregasAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryPanelaBrown),
      ),
      error: (e, _) => ErrorWidgetCustom(error: e.toString()),
      data: (entregas) {
        if (entregas.isEmpty) {
          return Center(
            child: Text(
              'Sin entregas registradas',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textDark.withAlpha(120),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: entregas.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final entrega = entregas[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(entrega.fechaEntrega),
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.qr_code_2_outlined,
                  color: AppColors.primaryPanelaBrown,
                  size: 30,
                ),
                tooltip: 'Ver QR',
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    'entregaDetail',
                    pathParameters: {
                      'moliendaId': moliendaId,
                      'entregaId': entrega.id,
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
