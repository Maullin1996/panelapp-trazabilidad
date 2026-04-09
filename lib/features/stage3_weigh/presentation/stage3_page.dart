import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/widgets.dart';

class Stage3Page extends ConsumerWidget {
  final String projectId;
  const Stage3Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(stage1ProjectByIdProvider(projectId));
    final loads2 = ref
        .watch(syncStage2ProjectsProvider)
        .where((l) => l.projectId == projectId)
        .toList();

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PESAJE: ${project.name.toUpperCase()}',
          style: textTheme.headlineMedium,
        ),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: loads2.isEmpty
          ? EmptyWidget()
          : ListView.separated(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.medium,
                left: AppSpacing.small,
                right: AppSpacing.small,
                top: AppSpacing.smallLarge,
              ),
              itemCount: loads2.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: AppSpacing.small);
              },
              itemBuilder: (BuildContext context, int index) {
                final load2 = loads2[index];
                final summary = ref.watch(loadSummaryProvider(load2.id));
                final entry3 = ref
                    .watch(syncStage3ProjectsProvider)
                    .firstWhereOrNull((e) => e.stage2LoadId == load2.id);

                return GestureDetector(
                  onTap: () => _onLoadTap(context, project, load2, entry3),
                  child: CustomCard(
                    key: Key('stage3-page-${load2.id}-custom-card'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xSmall,
                            horizontal: AppSpacing.small,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDarkPanela,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppRadius.medium),
                              topRight: Radius.circular(AppRadius.medium),
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Registrado en Molienda',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppRadius.small),
                          child: Column(
                            children: [
                              CustomRichText(
                                icon: Icons.calendar_month,
                                firstText: 'Fecha: ',
                                secondText: DateFormat.yMd().format(load2.date),
                              ),

                              const SizedBox(height: AppSpacing.xSmall),
                              CustomRichText(
                                icon: Icons.inventory_2,
                                iconColor: AppColors.secondaryDarkPanela,
                                firstText: 'Enviadas: ',
                                secondText:
                                    '${load2.baskets.count} Canastillas',
                              ),
                              const SizedBox(height: AppSpacing.xSmall),
                              CustomRichText(
                                icon: Icons.scale,
                                iconColor: AppColors.weight,
                                firstText: 'Peso canastilla: ',
                                secondText:
                                    '${load2.baskets.realWeight.toStringAsFixed(2)} kg',
                              ),
                              const SizedBox(height: AppSpacing.xSmall),
                              CustomRichText(
                                icon: Icons.bar_chart,
                                iconColor: AppColors.register,
                                firstText: 'Peso total esperado: ',
                                secondText:
                                    '${summary.totalRefkg.toStringAsFixed(2)} kg',
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xSmall,
                            horizontal: AppSpacing.small,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDarkPanela,
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Registrado en bodega',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.small),
                          child: Column(
                            children: [
                              CustomRichText(
                                icon: Icons.all_inbox_rounded,
                                iconColor: AppColors.register,
                                firstText: 'Registradas: ',
                                secondText: '${summary.regCount} Canastillas',
                              ),

                              const SizedBox(height: AppSpacing.xSmall),
                              CustomRichText(
                                icon: Icons.check_box,
                                iconColor: AppColors.accepted,
                                firstText: 'Peso total registrado: ',
                                secondText:
                                    '${summary.regWeight.toStringAsFixed(2)} kg',
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xSmall,
                            horizontal: AppSpacing.small,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryDarkPanela,
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                'Canastillas y Peso faltante',
                                style: textTheme.headlineMedium?.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.small),
                          child: Column(
                            children: [
                              CustomRichText(
                                icon: Icons.priority_high,
                                iconColor: AppColors.error,
                                firstText: 'Faltan canastillas: ',
                                secondText: summary.missingCount.toString(),
                              ),

                              const SizedBox(height: AppSpacing.small),
                              CustomRichText(
                                icon: Icons.warning,
                                iconColor: AppColors.alert,
                                firstText: 'Peso faltante: ',
                                secondText:
                                    '${summary.missingWeight.toStringAsFixed(2)}kg',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _onLoadTap(
    BuildContext context,
    Stage1FormData project,
    Stage2LoadData load2,
    Stage3FormData? entry,
  ) {
    final textTheme = TextTheme.of(context);
    showDialog(
      context: context,
      builder: (dcontext) => AlertDialog(
        backgroundColor: AppColors.backgroundCrema,
        title: Center(
          child: Text('¿Qué deseas hacer?', style: textTheme.headlineMedium),
        ),
        actions: [
          if (entry != null)
            GestureDetector(
              onTap: () {
                Navigator.of(dcontext).pop();
                context.push('${Routes.stage3}/$projectId/${load2.id}/summary');
              },
              child: CustomCard(
                key: Key('stage3-page-summery-button'),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article, color: AppColors.textDark, size: 30),
                      SizedBox(width: AppSpacing.xSmall),
                      Expanded(
                        child: Text(
                          'Ver resumen',
                          style: textTheme.headlineSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              Navigator.of(dcontext).pop();
              context.push('${Routes.stage3}/$projectId/${load2.id}/form');
            },
            child: CustomCard(
              key: Key('stage3-page-form-button'),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.assignment, color: AppColors.textDark, size: 30),
                    SizedBox(width: AppSpacing.xSmall),
                    Expanded(
                      child: Text(
                        'Continuar formulario',
                        style: textTheme.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
