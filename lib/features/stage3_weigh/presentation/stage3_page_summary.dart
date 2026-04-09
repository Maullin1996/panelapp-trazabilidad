import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/index.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/widget/summary_card.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

class Stage3PageSummary extends ConsumerWidget {
  final String projectId;
  final String load2Id;
  const Stage3PageSummary({
    super.key,
    required this.projectId,
    required this.load2Id,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId))!;
    final load2 = ref.watch(stage2LoadsByIdProvider(load2Id))!;
    final entry3 = ref
        .watch(syncStage3ProjectsProvider)
        .firstWhereOrNull(
          (p) => p.projectId == project.id && p.stage2LoadId == load2.id,
        );
    if (entry3 == null) {
      return const Scaffold(body: Center(child: Text('Resumen no disponible')));
    }

    final summaryCalculus = ref.watch(loadSummaryProvider(load2Id));

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('PESAJE', style: textTheme.headlineMedium),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: CustomScrollView(
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
                  // tus 3 cards de resumen aquí sin cambios
                  SummaryCard(
                    title: 'Registrado en molienda',
                    firstTextCard1: 'Fecha cargue: ',
                    secondTextCard1: DateFormat.yMd().format(load2.date),
                    firstTextCard2: 'Peso esperado: ',
                    secondTextCard2:
                        '${summaryCalculus.totalRefkg.toStringAsFixed(2)} kg',
                    firstIcon: Icons.calendar_month,
                    firstIconColors: AppColors.weight,
                    secondIcon: Icons.bar_chart,
                    secondIconColors: AppColors.register,
                    textTheme: textTheme,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  SummaryCard(
                    textTheme: textTheme,
                    title: 'Registrado en bodega',
                    firstTextCard1: 'Registradas: ',
                    secondTextCard1: '${summaryCalculus.regCount} Canastillas',
                    firstTextCard2: 'Peso registrado: ',
                    secondTextCard2:
                        '${summaryCalculus.regWeight.toStringAsFixed(2)} kg',
                    firstIcon: Icons.all_inbox_rounded,
                    firstIconColors: AppColors.register,
                    secondIconColors: AppColors.accepted,
                    secondIcon: Icons.check_box,
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  SummaryCard(
                    textTheme: textTheme,
                    title: 'Faltantes',
                    firstTextCard1: 'Faltan: ',
                    secondTextCard1:
                        '${summaryCalculus.missingCount} Canastillas',
                    firstTextCard2: 'Peso faltante: ',
                    secondTextCard2:
                        '${summaryCalculus.missingWeight.toStringAsFixed(2)} kg',
                    firstIcon: Icons.priority_high,
                    firstIconColors: AppColors.error,
                    secondIconColors: AppColors.alert,
                    secondIcon: Icons.warning,
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
            itemCount: entry3.baskets.length,
            itemBuilder: (context, index) {
              final b = entry3.baskets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                ),
                child: _BasketCard(
                  basket: b,
                  load2: load2,
                  sequence: b.sequence,
                ),
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
  final Stage2LoadData load2;
  final int sequence;

  const _BasketCard({
    required this.basket,
    required this.load2,
    required this.sequence,
  });

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
                  imagePath: basket.photoPath,
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
                    icon: Icons.warning,
                    iconColor: AppColors.alert,
                    firstText: 'Peso faltante: ',
                    secondText:
                        '${(load2.baskets.realWeight - basket.realWeight).clamp(0, double.infinity).toStringAsFixed(2)} kg',
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    icon: Icons.verified,
                    iconColor: AppColors.accepted,
                    firstText: 'Calidad: ',
                    secondText: basket.quality.name.toUpperCase(),
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
