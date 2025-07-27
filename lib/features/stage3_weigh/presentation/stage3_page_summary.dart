import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage2_load/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';

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
    final load2 = ref.watch(stage2LoadsByIdProvider(projectId))!;
    // .where((l) => l.projectId == projectId)
    // .first;
    final entry3 = ref
        .watch(stage3LoadProvider)
        .where((p) => p.projectId == project.id)
        .first;

    // 2) Cálculos de totales
    final group = load2.baskets;
    final totalBaskets = group.count;
    final totalRefKg = group.realWeight * totalBaskets;

    final regCount =
        entry3.baskets.length; // cada elemento es una canastilla registrada
    final regWeight = entry3.baskets.fold<double>(
      0,
      (sum, b) => sum + b.realWeight,
    );

    final missingCount = totalBaskets - regCount;
    final missingWeight = totalRefKg - regWeight;

    final textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen pesaje', style: textTheme.headlineMedium),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.smallMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.smallLarge),
              child: Column(
                children: [
                  Center(
                    child: Text(project.name, style: textTheme.headlineMedium),
                  ),
                  const SizedBox(height: AppSpacing.medium),

                  Center(
                    child: Text(
                      'Registrado en molienda',
                      style: textTheme.headlineMedium,
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
                    icon: Icons.scale,
                    firstText: 'Peso esperado: ',
                    secondText: '${totalRefKg.toStringAsFixed(2)} kg',
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
                    icon: Icons.scale,
                    firstText: 'Peso registrado: ',
                    secondText: '${regWeight.toStringAsFixed(2)} kg',
                  ),

                  const SizedBox(height: AppSpacing.small),
                  Center(
                    child: Text('Faltantes', style: textTheme.headlineMedium),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  CustomRichText(
                    icon: Icons.shopping_basket,
                    firstText: 'Faltan canastillas: ',
                    secondText: missingCount.toString(),
                  ),

                  const SizedBox(height: AppSpacing.xSmall),
                  CustomRichText(
                    icon: Icons.scale,
                    firstText: 'Peso faltante: ',
                    secondText: '${missingWeight.toStringAsFixed(2)} kg',
                  ),
                  SizedBox(height: AppSpacing.medium),

                  Center(
                    child: Text(
                      'Detalle por canastilla',
                      style: textTheme.headlineMedium,
                    ),
                  ),
                ],
              ),
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
                          style: textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.scale,
                        firstText: 'Peso registrado: ',
                        secondText: '${b.realWeight.toStringAsFixed(2)} kg',
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.scale,
                        firstText: 'Peso faltante: ',
                        secondText:
                            '${(load2.baskets.realWeight - b.realWeight).toStringAsFixed(2)} kg',
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      CustomRichText(
                        icon: Icons.verified,
                        firstText: 'Calidad: ',
                        secondText: b.quality.name.toUpperCase(),
                      ),

                      const SizedBox(height: AppSpacing.xSmall),
                      if (b.photoPath.isNotEmpty)
                        Image.file(
                          File(b.photoPath),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
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
