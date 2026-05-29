import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/domain/entities/index.dart';
import 'package:core/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:core/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:core/features/stage3_weigh/helpers/quality_color.dart';
import 'package:core/features/stage3_weigh/providers/index.dart';
import 'package:core/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import '../shared/web_layout.dart';

class WebStage3Page extends ConsumerWidget {
  final String projectId;
  const WebStage3Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId));
    final loads2 = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == projectId)
        .toList();
    final isLoading = ref.watch(stage3LoadsLoadingProvider);
    final textTheme = TextTheme.of(context);

    if (project == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WebLayout(
      selectedIndex: 0,
      onDestinationSelected: (_) {},
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.secondaryDarkPanela.withAlpha(30),
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Text(
                  'Pesaje: ${project.name}'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
              ],
            ),
          ),

          // ── Contenido ─────────────────────────────────────────
          Expanded(
            child: isLoading && loads2.isEmpty
                ? const Stage3Shimmer(itemCount: 4)
                : loads2.isEmpty
                ? const EmptyWidget()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.medium),
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
                          DataColumn(label: Text('Canastillas enviadas')),
                          DataColumn(label: Text('Calidad')),
                          DataColumn(label: Text('Registradas')),
                          DataColumn(label: Text('Faltantes')),
                          DataColumn(label: Text('Acciones')),
                        ],
                        rows: loads2.map((load2) {
                          final summary = ref.watch(
                            loadSummaryProvider(load2.id),
                          );
                          final entry3 = ref
                              .watch(syncStage3ProjectsProvider)
                              .firstWhereOrNull(
                                (e) => e.stage2LoadId == load2.id,
                              );
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  DateFormat.yMd().format(load2.date),
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${load2.baskets.count}',
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              DataCell(
                                Text(
                                  load2.baskets.quality.label,
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${summary.regCount}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: AppColors.register,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  '${summary.missingCount}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: summary.missingCount > 0
                                        ? AppColors.error
                                        : AppColors.accepted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    if (entry3 != null)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.article_outlined,
                                          color: AppColors.register,
                                        ),
                                        tooltip: 'Ver resumen',
                                        onPressed: () => context.push(
                                          '${Routes.stage3}/$projectId/${load2.id}/summary',
                                        ),
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.primaryPanelaBrown,
                                      ),
                                      tooltip: 'Continuar formulario',
                                      onPressed: () => context.push(
                                        '${Routes.stage3}/$projectId/${load2.id}/form',
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
      ),
    );
  }
}
