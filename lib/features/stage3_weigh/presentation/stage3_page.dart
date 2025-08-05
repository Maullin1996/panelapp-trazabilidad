import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/index.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';

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

    final entries3 = ref.watch(syncStage3ProjectsProvider);

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesaje: ${project.name}', style: textTheme.headlineLarge),
        leading: BackButton(onPressed: () => context.go(Routes.projects)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(bottom: AppSpacing.medium),
        itemCount: loads2.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: AppSpacing.small);
        },
        itemBuilder: (BuildContext context, int index) {
          double sum = 0.0;
          final load2 = loads2[index];
          final group = load2.baskets;
          final totalBaskets = group.count;
          final realWeight = group.realWeight;
          final totalRefkg = totalBaskets * realWeight;

          final entry = entries3.firstWhereOrNull(
            (e) => e.stage2LoadId == load2.id,
          );
          if (entry != null) {
            for (var element in entry.baskets) {
              sum += element.realWeight;
            }
          }
          final regCount = entry?.baskets.length ?? 0;
          final regWeight = sum;
          final missingCount = totalBaskets - regCount;
          final missingWeight = totalRefkg - regWeight;

          return GestureDetector(
            onTap: () => _onLoadTap(context, project, load2, entry),
            child: CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.smallLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Registrado en Molienda',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: AppSpacing.small),
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
                      secondText: '$totalBaskets Canastillas',
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.scale,
                      iconColor: AppColors.weight,
                      firstText: 'Peso canastilla: ',
                      secondText: '${group.realWeight.toStringAsFixed(2)} kg',
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.bar_chart,
                      iconColor: AppColors.register,
                      firstText: 'Peso total esperado: ',
                      secondText: '${totalRefkg.toStringAsFixed(2)} kg',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Registrado en bodega',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.all_inbox_rounded,
                      iconColor: AppColors.register,
                      firstText: 'Registradas: ',
                      secondText: '$regCount Canastillas',
                    ),

                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.check_box,
                      iconColor: AppColors.accepted,
                      firstText: 'Peso total registrado: ',
                      secondText: '${regWeight.toStringAsFixed(2)} kg',
                    ),

                    const SizedBox(height: AppSpacing.small),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'Canastillas y Peso faltante',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                    ),
                    const Divider(thickness: 2),
                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.priority_high,
                      iconColor: AppColors.error,
                      firstText: 'Faltan canastillas: ',
                      secondText: missingCount.toString(),
                    ),

                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.warning,
                      iconColor: AppColors.alert,
                      firstText: 'Peso faltante: ',
                      secondText: '${missingWeight.toStringAsFixed(2)}kg',
                    ),
                  ],
                ),
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
        backgroundColor: AppColors.cardBackground,
        title: Text('¿Qué deseas hacer?', style: textTheme.headlineMedium),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (entry != null)
                TextButton(
                  onPressed: () {
                    context.pop(dcontext);
                    context.push(
                      '${Routes.stage3}/$projectId/${load2.id}/summary',
                    );
                  },
                  child: Text('Ver resumen', style: textTheme.headlineSmall),
                ),
              TextButton(
                onPressed: () {
                  context.pop(dcontext);
                  context.push('${Routes.stage3}/$projectId/${load2.id}/form');
                },
                child: Text(
                  'Continuar formulario',
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
