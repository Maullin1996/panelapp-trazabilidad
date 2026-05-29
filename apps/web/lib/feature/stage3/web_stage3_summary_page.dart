import 'package:collection/collection.dart';
import 'package:core/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/features/stage3_weigh/helpers/quality_color.dart';
import 'package:core/features/stage3_weigh/providers/index.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import '../shared/web_layout.dart';

class WebStage3SummaryPage extends ConsumerWidget {
  final String projectId;
  final String load2Id;

  const WebStage3SummaryPage({
    required this.projectId,
    required this.load2Id,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId));
    final load2 = ref.watch(stage2LoadsByIdProvider(load2Id));
    final entry3 = ref
        .watch(syncStage3ProjectsProvider)
        .firstWhereOrNull(
          (p) => p.projectId == projectId && p.stage2LoadId == load2Id,
        );
    final textTheme = TextTheme.of(context);

    if (project == null || load2 == null || entry3 == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final summaryCalculus = ref.watch(loadSummaryProvider(load2Id));

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
                  'Resumen pesaje'.toUpperCase(),
                  style: textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryPanelaBrown,
                  ),
                ),
              ],
            ),
          ),

          // ── Contenido en dos columnas ──────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Resumen superior en Row ────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SummaryCard(
                              title: 'Registrado en molienda',
                              firstTextCard1: 'Fecha cargue: ',
                              secondTextCard1: DateFormat.yMd().format(
                                load2.date,
                              ),
                              firstTextCard2: 'Total enviadas: ',
                              secondTextCard2:
                                  '${summaryCalculus.totalBaskets} canastillas',
                              firstIcon: Icons.calendar_month,
                              firstIconColors: AppColors.weight,
                              secondIcon: Icons.inventory_2,
                              secondIconColors: AppColors.secondaryDarkPanela,
                              textTheme: textTheme,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: SummaryCard(
                              textTheme: textTheme,
                              title: 'Registrado en bodega',
                              firstTextCard1: 'Registradas: ',
                              secondTextCard1:
                                  '${summaryCalculus.regCount} canastillas',
                              firstTextCard2: 'Faltan: ',
                              secondTextCard2:
                                  '${summaryCalculus.missingCount} canastillas',
                              firstIcon: Icons.all_inbox_rounded,
                              firstIconColors: AppColors.register,
                              secondIconColors: AppColors.error,
                              secondIcon: Icons.priority_high,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.small),
                          Expanded(
                            child: CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppSpacing.small,
                                      right: AppSpacing.small,
                                      top: AppSpacing.xSmall,
                                    ),
                                    child: Text(
                                      'Calidad',
                                      style: textTheme.headlineMedium?.copyWith(
                                        color: AppColors.primaryPanelaBrown,
                                        fontWeight: FontWeight.w600,
                                      ),
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
                                      color: AppColors.secondaryDarkPanela
                                          .withAlpha(45),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: AppSpacing.small,
                                      right: AppSpacing.small,
                                      bottom: AppSpacing.small,
                                    ),
                                    child: Column(
                                      children: BasketQuality.values
                                          .where(
                                            (q) => summaryCalculus
                                                .countByQuality
                                                .containsKey(q),
                                          )
                                          .map(
                                            (q) => Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: AppSpacing.xSmall,
                                              ),
                                              child: CustomRichText(
                                                icon: Icons.label_outline,
                                                iconColor: qualityColor(
                                                  quality: q.label,
                                                ),
                                                firstText: '${q.label}: ',
                                                secondText:
                                                    '${summaryCalculus.countByQuality[q]}',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.medium),

                      // ── Tabla detalle canastillas ──────────────
                      Text(
                        'DETALLE POR CANASTILLA',
                        style: textTheme.labelMedium?.copyWith(
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Card(
                        color: AppColors.cardBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.large),
                        ),
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.primaryPanelaBrown.withAlpha(15),
                          ),
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Peso real (kg)')),
                            DataColumn(label: Text('Calidad')),
                            DataColumn(label: Text('Foto')),
                          ],
                          rows: entry3.baskets.map((b) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    '#${b.sequence + 1}',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.secondaryDarkPanela,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${b.realWeight.toStringAsFixed(2)} kg',
                                    style: textTheme.bodyMedium,
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    b.quality.label,
                                    style: textTheme.bodyMedium?.copyWith(
                                      color: qualityColor(
                                        quality: b.quality.label,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  b.photoPath.isNotEmpty
                                      ? InkWell(
                                          onTap: () => context.push(
                                            Routes.imageViewer,
                                            extra: b.photoPath,
                                          ),
                                          child: const Icon(
                                            Icons.image_outlined,
                                            color: AppColors.register,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: AppColors.weight,
                                        ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
