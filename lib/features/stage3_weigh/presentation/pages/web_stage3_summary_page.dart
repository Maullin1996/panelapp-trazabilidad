import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/helpers/quality_color.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/index.dart';
import 'package:registro_panela/core/theme/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';
import '../../../shared/web_layout.dart';

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

          // ── Contenido ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.medium),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Cards de resumen ──────────────────────
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 900;
                          final cards = [
                            SummaryCard(
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
                            SummaryCard(
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
                            CustomCard(
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
                          ];

                          if (isNarrow) {
                            return Column(
                              children: cards
                                  .map(
                                    (c) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.small,
                                      ),
                                      child: c,
                                    ),
                                  )
                                  .toList(),
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: cards[0]),
                              const SizedBox(width: AppSpacing.small),
                              Expanded(child: cards[1]),
                              const SizedBox(width: AppSpacing.small),
                              Expanded(child: cards[2]),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.medium),

                      // ── Grid de canastillas ───────────────────
                      Padding(
                        padding: const EdgeInsets.only(left: 2, bottom: 6),
                        child: Text(
                          'DETALLE POR CANASTILLA',
                          style: textTheme.labelMedium?.copyWith(
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final w = constraints.maxWidth;
                          final cols = w < 550
                              ? 1
                              : w < 850
                              ? 2
                              : w < 1150
                              ? 3
                              : 4;
                          final cardWidth =
                              (w - AppSpacing.medium * (cols - 1)) / cols;
                          return Wrap(
                            spacing: AppSpacing.medium,
                            runSpacing: AppSpacing.medium,
                            children: entry3.baskets.map((b) {
                              return SizedBox(
                                width: cardWidth,
                                child: _WebBasketCard(basket: b),
                              );
                            }).toList(),
                          );
                        },
                      ),

                      const SizedBox(height: AppSpacing.mediumLarge),
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

class _WebBasketCard extends StatelessWidget {
  final BasketWeighData basket;

  const _WebBasketCard({required this.basket});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.small,
              right: AppSpacing.small,
              top: AppSpacing.small,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryDarkPanela.withAlpha(20),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    border: Border.all(
                      color: AppColors.secondaryDarkPanela.withAlpha(60),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '#${basket.sequence + 1}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryDarkPanela,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Text(
                  'Canastilla',
                  style: textTheme.headlineMedium?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ── Imagen ────────────────────────────────────────────
          if (basket.photoPath.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xSmall),
            GestureDetector(
              onTap: () =>
                  context.push(Routes.imageViewer, extra: basket.photoPath),
              child: Center(
                child: StageImageWidget(
                  imageUrl: basket.photoPath,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],

          // ── Datos ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.small),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.weight.withAlpha(38),
                borderRadius: BorderRadius.all(
                  Radius.circular(AppRadius.medium),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.small),
              child: Column(
                children: [
                  CustomRichText(
                    icon: Icons.scale,
                    iconColor: AppColors.weight,
                    firstText: 'Peso registrado: ',
                    secondText: '${basket.realWeight.toStringAsFixed(2)} kg',
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    icon: Icons.storage,
                    iconColor: AppColors.weight,
                    firstText: 'Gavera: ',
                    secondText: '${basket.referenceWeight} g',
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    icon: Icons.verified,
                    iconColor: qualityColor(quality: basket.quality.label),
                    firstText: 'Calidad: ',
                    secondText: basket.quality.label,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
