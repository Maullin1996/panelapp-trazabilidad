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
import 'package:registro_panela/features/stage3_weigh/domain/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';
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

    final entries3 = ref.watch(stage3LoadProvider);

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesaje: ${project.name}', style: textTheme.headlineMedium),
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
                      child: Text(
                        'Registrado en Molienda',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.calendar_month,
                      firstText: 'Fecha: ',
                      secondText: DateFormat.yMd().format(load2.date),
                    ),

                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.shopping_basket,
                      firstText: 'Canastillas enviadas: ',
                      secondText: totalBaskets.toString(),
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.scale,
                      firstText: 'Peso canastilla: ',
                      secondText: '${group.realWeight.toStringAsFixed(2)} kg',
                    ),
                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.scale,
                      firstText: 'Peso total esperado: ',
                      secondText: '${totalRefkg.toStringAsFixed(2)} kg',
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Center(
                      child: Text(
                        'Registrado en bodega',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.shopping_basket,
                      firstText: 'Canastillas registradas: ',
                      secondText: regCount.toString(),
                    ),

                    const SizedBox(height: AppSpacing.xSmall),
                    CustomRichText(
                      icon: Icons.shopping_basket,
                      firstText: 'Peso total registrado: ',
                      secondText: '${regWeight.toStringAsFixed(2)} kg',
                    ),

                    const SizedBox(height: AppSpacing.small),
                    Center(
                      child: Text(
                        'Canastillas y Peso faltante',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.shopping_basket,
                      firstText: 'Faltan canastillas: ',
                      secondText: missingCount.toString(),
                    ),

                    const SizedBox(height: AppSpacing.small),
                    CustomRichText(
                      icon: Icons.scale,
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
        title: Text('¿Qué deseas hacer?', style: textTheme.headlineMedium),
        actions: [
          if (entry != null)
            TextButton(
              onPressed: () {
                context.pop(dcontext);
                context.push(
                  '${Routes.stage3}/${project.id}/${load2.id}/summary',
                );
              },
              child: Text('Ver resumen', style: textTheme.bodyLarge),
            ),
          TextButton(
            onPressed: () {
              context.pop(dcontext);
              context.push('${Routes.stage3}/$projectId/${load2.id}/form');
            },
            child: Text('Continuar formulario', style: textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
