import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/auth/domain/enums/user_role.dart';
import 'package:core/features/auth/providers/auth_provider.dart';
import 'package:core/features/stage5_2_records/providers/providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class WebStage52Page extends ConsumerWidget {
  final String projectId;
  const WebStage52Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(stage52ByProjectProvider(projectId));
    final summary = ref.watch(stage52SummaryProvider(projectId));
    final user = ref.watch(authProvider).user;
    final isLoading = ref.watch(stage52LoadingProvider);
    final textTheme = TextTheme.of(context);

    if (isLoading && records.isEmpty) {
      return const Stage52Shimmer(itemCount: 6);
    }

    return Column(
      children: [
        // ── Barra de resumen ──────────────────────────────────
        Container(
          margin: const EdgeInsets.all(AppSpacing.medium),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(
              color: AppColors.primaryPanelaBrown.withAlpha(25),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              _SummaryItem(value: '${summary.count}', label: 'Registros'),
              _SummaryDivider(),
              _SummaryItem(value: '${summary.units}', label: 'Unidades'),
              _SummaryDivider(),
              _SummaryItem(
                value: '${summary.kg.toStringAsFixed(1)} kg',
                label: 'Total gavera',
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.medium),
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.push('${Routes.stage5}/$projectId/records/form'),
                  icon: const Icon(Icons.add, color: AppColors.cardBackground),
                  label: Text(
                    'Nuevo registro',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.cardBackground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Tabla ────────────────────────────────────────────
        Expanded(
          child: records.isEmpty
              ? const EmptyWidget()
              : SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                  ),
                  child: Card(
                    color: AppColors.cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.large),
                    ),
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        AppColors.primaryPanelaBrown.withAlpha(15),
                      ),
                      columns: const [
                        DataColumn(label: Text('Fecha')),
                        DataColumn(label: Text('Gavera (g)')),
                        DataColumn(label: Text('Peso panela (kg)')),
                        DataColumn(label: Text('Unidades')),
                        DataColumn(label: Text('Calidad')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: records.map((r) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                DateFormat.yMd().format(r.date),
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r.gaveraWeight} g',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r.panelaWeight.toStringAsFixed(2)} kg',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                '${r.unitCount}',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                r.quality.name.toUpperCase(),
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.article_outlined,
                                      color: AppColors.register,
                                    ),
                                    tooltip: 'Ver resumen',
                                    onPressed: () => context.push(
                                      '${Routes.stage5}/$projectId/records/${r.id}/summary',
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      color: AppColors.primaryPanelaBrown,
                                    ),
                                    tooltip: 'Editar',
                                    onPressed: () => context.push(
                                      '${Routes.stage5}/$projectId/records/${r.id}/edit',
                                    ),
                                  ),
                                  if (user?.role == UserRole.admin)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.error,
                                      ),
                                      tooltip: 'Eliminar',
                                      onPressed: () => _confirmDelete(
                                        context,
                                        ref,
                                        r.id,
                                        textTheme,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    TextTheme textTheme,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('¿Eliminar registro?', style: textTheme.headlineLarge),
        content: Text(
          'Esta acción no se puede deshacer.',
          style: textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: textTheme.bodyLarge),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await ref.read(deleteStage52DataProvider).call(id);
    }
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextTheme.of(context).headlineLarge?.copyWith(
              color: AppColors.primaryPanelaBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.secondaryDarkPanela,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      height: 36,
      color: AppColors.textDark.withAlpha(12),
    );
  }
}
