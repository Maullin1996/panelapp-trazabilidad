import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/index.dart';
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
        title: Text('PESAJE', style: textTheme.headlineLarge),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: AppSpacing.mediumLarge,
          left: AppSpacing.small,
          right: AppSpacing.small,
          top: AppSpacing.smallLarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                CustomCard(
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Registrado en molienda',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      CustomRichText(
                        icon: Icons.calendar_month,
                        firstText: 'Fecha cargue: ',
                        secondText: DateFormat.yMd().format(load2.date),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.bar_chart,
                        iconColor: AppColors.register,
                        firstText: 'Peso esperado: ',
                        secondText:
                            '${summaryCalculus.totalRefkg.toStringAsFixed(2)} kg',
                      ),
                    ],
                  ),
                ),

                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Registrado en bodega',
                            style: textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        CustomRichText(
                          icon: Icons.all_inbox_rounded,
                          iconColor: AppColors.register,
                          firstText: 'Registradas: ',
                          secondText: '${summaryCalculus.regCount} Canastillas',
                        ),

                        const SizedBox(height: AppSpacing.xSmall),
                        CustomRichText(
                          icon: Icons.check_box,
                          iconColor: AppColors.accepted,
                          firstText: 'Peso registrado: ',
                          secondText:
                              '${summaryCalculus.regWeight.toStringAsFixed(2)} kg',
                        ),
                      ],
                    ),
                  ),
                ),

                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Faltantes',
                            style: textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        CustomRichText(
                          icon: Icons.priority_high,
                          iconColor: AppColors.error,
                          firstText: 'Faltan: ',
                          secondText:
                              '${summaryCalculus.missingCount} Canastillas',
                        ),

                        const SizedBox(height: AppSpacing.xSmall),
                        CustomRichText(
                          icon: Icons.warning,
                          iconColor: AppColors.alert,
                          firstText: 'Peso faltante: ',
                          secondText:
                              '${summaryCalculus.missingWeight.toStringAsFixed(2)} kg',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.small),

                Center(
                  child: Text(
                    'Detalle por canastilla',
                    style: textTheme.headlineLarge,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.smallLarge),

            // Listado de cada canastilla
            ...entry3.baskets.map((b) {
              return CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.smallLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Canastilla #${b.sequence + 1}',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.scale,
                        iconColor: AppColors.weight,
                        firstText: 'Peso registrado: ',
                        secondText: '${b.realWeight.toStringAsFixed(2)} kg',
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.warning,
                        iconColor: AppColors.alert,
                        firstText: 'Peso faltante: ',
                        secondText:
                            '${(load2.baskets.realWeight - b.realWeight).clamp(0, double.infinity).toStringAsFixed(2)} kg',
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.verified,
                        iconColor: AppColors.accepted,
                        firstText: 'Calidad: ',
                        secondText: b.quality.name.toUpperCase(),
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      if (b.photoPath.isNotEmpty)
                        GestureDetector(
                          onTap: () => context.push(
                            Routes.imageViewer,
                            extra: b.photoPath,
                          ),
                          child: Center(
                            child: StageImageWidget(
                              imagePath: b.photoPath,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
