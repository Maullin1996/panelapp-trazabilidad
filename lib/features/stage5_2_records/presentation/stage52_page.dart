import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/stage5_2_records/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';

class Stage52Page extends ConsumerWidget {
  final String projectId;
  const Stage52Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref
        .watch(syncStage52LoadsProvider)
        .where((r) => r.projectId == projectId)
        .toList();

    final textTheme = TextTheme.of(context);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.large),
        itemCount: records.length,
        itemBuilder: (_, i) {
          final r = records[i];
          return CustomCard(
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.cardBackground,
                  title: Text(
                    '¿Qué quieres hacer?',
                    style: textTheme.headlineMedium,
                  ),
                  actions: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              '${Routes.stage5}/$projectId/records/${r.id}/summary',
                            );
                          },
                          child: Text(
                            'Ver resumen',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.push(
                              '${Routes.stage5}/$projectId/records/${r.id}/edit',
                            );
                          },
                          child: Text(
                            'Editar registro',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomRichText(
                            icon: Icons.unarchive_outlined,
                            iconColor: AppColors.textDark,
                            firstText: 'Unidades de panela: ',
                            secondText: r.unitCount.toString(),
                          ),
                          SizedBox(height: AppSpacing.xSmall),
                          CustomRichText(
                            icon: Icons.scale,
                            iconColor: AppColors.weight,
                            firstText: 'Peso paquete: ',
                            secondText: '${r.gaveraWeight.toStringAsFixed(0)}g',
                          ),
                          SizedBox(height: AppSpacing.xSmall),
                          CustomRichText(
                            icon: Icons.storage_outlined,
                            iconColor: AppColors.weight,
                            firstText: 'Gavera: ',
                            secondText:
                                '${r.panelaWeight.toStringAsFixed(2)} kg',
                          ),
                          SizedBox(height: AppSpacing.xSmall),
                          CustomRichText(
                            icon: Icons.verified,
                            iconColor: AppColors.accepted,
                            firstText: 'Calidad: ',
                            secondText: r.quality.name.toUpperCase(),
                          ),
                        ],
                      ),
                    ),
                    if (r.photoPath.isNotEmpty)
                      StageImageWidget(
                        imagePath: r.photoPath,
                        width: 100,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.smallLarge),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton.icon(
              onPressed: () {
                context.push('${Routes.stage5}/$projectId/records/form');
              },
              label: Text(
                'Nuevo registro',
                style: TextTheme.of(context).headlineLarge,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
