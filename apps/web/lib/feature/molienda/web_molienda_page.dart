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
          child: CircularProgressIndicator(
            color: AppColors.primaryPanelaBrown,
          ),
        ),
        error: (e, _) => ErrorWidgetCustom(error: e.toString()),
        data: (moliendas) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: CustomCard(
                child: moliendas.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        child: Center(
                          child: Text(
                            'Sin moliendas registradas',
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textDark.withAlpha(120),
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.primaryPanelaBrown.withAlpha(15),
                          ),
                          columns: [
                            DataColumn(
                              label: Text(
                                'Nombre',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Teléfono',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Fecha creación',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Acciones',
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                          rows: moliendas
                              .map((m) => _buildRow(context, ref, m))
                              .toList(),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, WidgetRef ref, Molienda m) {
    return DataRow(
      cells: [
        DataCell(Text(m.nombre)),
        DataCell(Text(m.telefono)),
        DataCell(Text(DateFormat('dd/MM/yyyy').format(m.creadoEn))),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.local_shipping_outlined,
                  color: AppColors.weight,
                  size: 18,
                ),
                tooltip: 'Ver entregas',
                onPressed: () => _showEntregasDialog(context, m),
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryPanelaBrown,
                  size: 18,
                ),
                onPressed: () => _showFormDialog(context, ref, molienda: m),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: 18,
                ),
                onPressed: () => _confirmDelete(context, ref, m.id),
              ),
            ],
          ),
        ),
      ],
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
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(ctx).bottom,
          ),
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
                Expanded(child: _EntregasList(moliendaId: molienda.id)),
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
              style: textTheme.bodyMedium?.copyWith(
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
                style: textTheme.bodyMedium,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.qr_code_2_outlined,
                  color: AppColors.primaryPanelaBrown,
                  size: 20,
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
