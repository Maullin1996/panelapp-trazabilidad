import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/providers/auth_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_usecases_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/sync_stage52_loads_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';
import 'package:registro_panela/shared/widgets/empty_widget.dart';
import 'package:registro_panela/shared/widgets/stage_image_widget.dart';

class Stage52Page extends ConsumerWidget {
  final String projectId;
  const Stage52Page({super.key, required this.projectId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(stage52ByProjectProvider(projectId));

    final textTheme = TextTheme.of(context);

    if (records.isEmpty) {
      return Scaffold(
        body: EmptyWidget(),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.smallLarge),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                key: Key('stage52-page-form-button-empty'),
                onPressed: () {
                  context.push('${Routes.stage5}/$projectId/records/form');
                },
                label: Text('Nuevo registro', style: textTheme.headlineLarge),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: AppSpacing.large),
        itemCount: records.length,
        itemBuilder: (_, i) {
          final r = records[i];
          final user = ref.read(authProvider).user;
          return Dismissible(
            key: Key('data-selector-dismissible-${r.id}'),
            direction: user != null && user.role == UserRole.admin
                ? DismissDirection.endToStart
                : DismissDirection.none,
            confirmDismiss: (_) async {
              return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.cardBackground,
                      title: Text(
                        '¿Eliminar proyecto?',
                        style: textTheme.headlineLarge,
                      ),
                      content: Text(
                        'Esta acción no se puede deshacer.',
                        style: textTheme.bodyLarge,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('Cancelar', style: textTheme.bodyLarge),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ) ??
                  false;
            },
            onDismissed: (_) async {
              await ref.read(deleteStage52DataProvider).call(r.id);
            },
            background: Container(
              margin: const EdgeInsets.only(
                left: AppSpacing.smallLarge,
                right: AppSpacing.smallLarge,
                bottom: AppSpacing.small,
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppSpacing.smallLarge),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete, color: Colors.white, size: 30),
            ),
            child: CustomCard(
              child: InkWell(
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: AppColors.backgroundCrema,
                    title: Center(
                      child: Text(
                        '¿Qué quieres hacer?',
                        style: textTheme.headlineMedium,
                      ),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                          context.push(
                            '${Routes.stage5}/$projectId/records/${r.id}/summary',
                          );
                        },
                        child: CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.article,
                                  color: AppColors.textDark,
                                  size: 30,
                                ),
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
                          context.pop();
                          context.push(
                            '${Routes.stage5}/$projectId/records/${r.id}/edit',
                          );
                        },
                        child: CustomCard(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: AppColors.textDark,
                                  size: 30,
                                ),
                                SizedBox(width: AppSpacing.xSmall),
                                Expanded(
                                  child: Text(
                                    'Editar registro',
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
                            const SizedBox(height: AppSpacing.xSmall),
                            CustomRichText(
                              icon: Icons.scale,
                              iconColor: AppColors.weight,
                              firstText: 'Peso paquete: ',
                              secondText:
                                  '${r.gaveraWeight.toStringAsFixed(0)}g',
                            ),
                            const SizedBox(height: AppSpacing.xSmall),
                            CustomRichText(
                              icon: Icons.storage_outlined,
                              iconColor: AppColors.weight,
                              firstText: 'Gavera: ',
                              secondText:
                                  '${r.panelaWeight.toStringAsFixed(2)} kg',
                            ),
                            const SizedBox(height: AppSpacing.xSmall),
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
              key: Key('stage52-page-form-button-list'),
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
