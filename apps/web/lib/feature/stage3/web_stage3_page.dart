import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/domain/entities/index.dart';
import 'package:core/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage3_weigh/helpers/quality_color.dart';
import 'package:core/features/stage3_weigh/providers/index.dart';
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
          Expanded(
            child: isLoading && loads2.isEmpty
                ? const Stage3Shimmer(itemCount: 4)
                : loads2.isEmpty
                ? const EmptyWidget()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth;
                        final cols = w < 650 ? 1 : w < 1050 ? 2 : 3;
                        final cardWidth =
                            (w - AppSpacing.medium * (cols - 1)) / cols;
                        return Wrap(
                          spacing: AppSpacing.medium,
                          runSpacing: AppSpacing.medium,
                          children: loads2.map((load2) {
                            final summary =
                                ref.watch(loadSummaryProvider(load2.id));
                            final entry3 = ref
                                .watch(syncStage3ProjectsProvider)
                                .firstWhereOrNull(
                                  (e) => e.stage2LoadId == load2.id,
                                );
                            return SizedBox(
                              width: cardWidth,
                              child: _WebLoad2Card(
                                load2: load2,
                                summary: summary,
                                hasEntry3: entry3 != null,
                                onGoToSummary: () => context.push(
                                  '${Routes.stage3}/$projectId/${load2.id}/summary',
                                ),
                                onGoToForm: () => context.push(
                                  '${Routes.stage3}/$projectId/${load2.id}/form',
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _WebLoad2Card extends StatelessWidget {
  final Stage2LoadData load2;
  final LoadSummary summary;
  final bool hasEntry3;
  final VoidCallback onGoToSummary;
  final VoidCallback onGoToForm;

  const _WebLoad2Card({
    required this.load2,
    required this.summary,
    required this.hasEntry3,
    required this.onGoToSummary,
    required this.onGoToForm,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Molienda ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.unarchive,
                  iconColor: AppColors.alert,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    'Registrado en Molienda',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              bottom: AppSpacing.smallLarge,
            ),
            child: Column(
              children: [
                CustomRichText(
                  icon: Icons.calendar_month,
                  size: 15,
                  firstText: 'Fecha: ',
                  secondText: DateFormat.yMd().format(load2.date),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.inventory_2,
                  iconColor: AppColors.secondaryDarkPanela,
                  size: 15,
                  firstText: 'Enviadas: ',
                  secondText: '${load2.baskets.count} Canastillas',
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.verified,
                  iconColor: AppColors.accepted,
                  size: 15,
                  firstText: 'Calidad: ',
                  secondText: load2.baskets.quality.label,
                ),
                const SizedBox(height: AppSpacing.xSmall),
                CustomRichText(
                  icon: Icons.storage,
                  iconColor: AppColors.weight,
                  size: 15,
                  firstText: 'Gavera: ',
                  secondText: '${load2.baskets.referenceWeight} g',
                ),
              ],
            ),
          ),

          // ── Bodega ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.warehouse,
                  iconColor: AppColors.register,
                  backgroundColor: AppColors.register,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    'Registrado en bodega',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                  icon: Icons.all_inbox_rounded,
                  iconColor: AppColors.register,
                  size: 15,
                  firstText: 'Registradas: ',
                  secondText: '${summary.regCount} Canastillas',
                ),
                const SizedBox(height: AppSpacing.xSmall),
                ...BasketQuality.values
                    .where((q) => summary.countByQuality.containsKey(q))
                    .map(
                      (q) => Padding(
                        padding: const EdgeInsets.only(
                          left: AppSpacing.small,
                          bottom: AppSpacing.xSmall,
                        ),
                        child: CustomRichText(
                          icon: Icons.circle,
                          size: 12,
                          backgroundDecoration: false,
                          iconColor: qualityColor(quality: q.label),
                          firstText: '${q.label}: ',
                          secondText: '${summary.countByQuality[q]}',
                        ),
                      ),
                    ),
              ],
            ),
          ),

          // ── Faltantes ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
            ),
            child: Row(
              children: [
                IconDecoration(
                  icon: Icons.error_outlined,
                  iconColor: AppColors.error,
                  backgroundColor: AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: Text(
                    'Canastillas faltantes',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
              bottom: AppSpacing.xSmall,
            ),
            child: CustomRichText(
              icon: Icons.priority_high,
              size: 15,
              iconColor: AppColors.error,
              firstText: 'Faltan: ',
              secondText: '${summary.missingCount} canastillas',
            ),
          ),

          // ── Acciones ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.xSmall,
              bottom: AppSpacing.small,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasEntry3)
                  IconButton(
                    icon: const Icon(
                      Icons.article_outlined,
                      color: AppColors.register,
                    ),
                    tooltip: 'Ver resumen',
                    onPressed: onGoToSummary,
                  ),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.primaryPanelaBrown,
                  ),
                  tooltip: 'Continuar formulario',
                  onPressed: onGoToForm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
