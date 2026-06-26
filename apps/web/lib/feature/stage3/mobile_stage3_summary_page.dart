import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'package:core/core/router/routes.dart';
import 'package:core/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:core/features/stage2_load/domain/entities/basket_quality_label.dart';
import 'package:core/features/stage2_load/providers/providers.dart';
import 'package:core/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:core/features/stage3_weigh/helpers/quality_color.dart';
import 'package:core/features/stage3_weigh/providers/index.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class Stage3PageSummary extends ConsumerStatefulWidget {
  final String projectId;
  final String load2Id;
  const Stage3PageSummary({
    super.key,
    required this.projectId,
    required this.load2Id,
  });

  @override
  ConsumerState<Stage3PageSummary> createState() => _Stage3PageSummaryState();
}

class _Stage3PageSummaryState extends ConsumerState<Stage3PageSummary> {
  int _loadedCount = 15;
  int _totalBaskets = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_loadedCount < _totalBaskets) {
        setState(() => _loadedCount += 15);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId))!;
    final load2 = ref.watch(stage2LoadsByIdProvider(widget.load2Id))!;
    final entry3 = ref
        .watch(syncStage3ProjectsProvider)
        .firstWhereOrNull(
          (p) => p.projectId == project.id && p.stage2LoadId == load2.id,
        );
    if (entry3 == null) {
      return const Scaffold(body: Center(child: Text('Resumen no disponible')));
    }

    final summaryCalculus = ref.watch(loadSummaryProvider(widget.load2Id));

    final visibleBaskets = entry3.baskets.take(_loadedCount).toList();

    _totalBaskets = entry3.baskets.length;

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('PESAJE', style: textTheme.headlineMedium),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── Sección resumen (estático, no cambia) ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.small,
                right: AppSpacing.small,
                top: AppSpacing.smallLarge,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryCard(
                    title: 'Registrado en molienda',
                    firstTextCard1: 'Fecha cargue: ',
                    secondTextCard1: DateFormat.yMd().format(load2.date),
                    firstTextCard2: 'Total enviadas: ',
                    secondTextCard2:
                        '${summaryCalculus.totalBaskets} canastillas',
                    firstIcon: Icons.calendar_month,
                    firstIconColors: AppColors.weight,
                    secondIcon: Icons.inventory_2,
                    secondIconColors: AppColors.secondaryDarkPanela,
                    textTheme: textTheme,
                  ),

                  const SizedBox(height: AppSpacing.xSmall),
                  SummaryCard(
                    textTheme: textTheme,
                    title: 'Registrado en bodega',
                    firstTextCard1: 'Registradas: ',
                    secondTextCard1: '${summaryCalculus.regCount} canastillas',
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
                            "Calidad",
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
                            color: AppColors.secondaryDarkPanela.withAlpha(45),
                          ),
                        ),
                        if (summaryCalculus.countByQuality.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xSmall),
                          ...BasketQuality.values
                              .where(
                                (q) => summaryCalculus.countByQuality
                                    .containsKey(q),
                              )
                              .map(
                                (q) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: AppSpacing.smallLarge,
                                    bottom: AppSpacing.xSmall,
                                  ),
                                  child: CustomRichText(
                                    icon: Icons.label_outline,
                                    iconColor: qualityColor(quality: q.label),
                                    firstText: '${q.label}: ',
                                    secondText:
                                        '${summaryCalculus.countByQuality[q]}',
                                  ),
                                ),
                              ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.small),
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
                ],
              ),
            ),
          ),

          // ── Listado lazy de canastillas ──
          SliverList.separated(
            separatorBuilder: (_, _) =>
                const SizedBox(height: AppSpacing.small),
            itemCount: visibleBaskets.length,
            itemBuilder: (context, index) {
              final b = visibleBaskets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                ),
                child: _BasketCard(basket: b, sequence: b.sequence),
              );
            },
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.mediumLarge),
          ),
        ],
      ),
    );
  }
}

class _BasketCard extends StatelessWidget {
  final BasketWeighData basket;
  final int sequence;

  const _BasketCard({required this.basket, required this.sequence});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── header compacto ──
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
                    '#${sequence + 1}',
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

          // ── imagen ──
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

          // ── datos ──
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
                    secondText: "${basket.referenceWeight.toString()} g",
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    icon: Icons.verified,
                    iconColor: qualityColor(quality: basket.quality.label),
                    firstText: 'Calidad: ',
                    secondText: basket
                        .quality
                        .label, // ← .label en vez de .name.toUpperCase()
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
