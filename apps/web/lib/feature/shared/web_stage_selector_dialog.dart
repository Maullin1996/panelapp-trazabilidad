import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/stage_selector_page.dart';

class WebStageSelectorDialog extends StatelessWidget {
  final String projectId;

  const WebStageSelectorDialog({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    return Dialog(
      backgroundColor: AppColors.backgroundCrema,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.large),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  Text(
                    'Seleccionar Etapa',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.primaryPanelaBrown,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    tooltip: 'Cerrar',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.small),
              Divider(
                height: 1,
                thickness: 1,
                color: AppColors.secondaryDarkPanela.withAlpha(30),
              ),
              const SizedBox(height: AppSpacing.small),

              // ── Etapas ──────────────────────────────────────
              for (var stage = 1; stage <= 5; stage++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
                  child: Material(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.push('${byStage(stage)}/$projectId');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.small,
                          vertical: AppSpacing.xSmall,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.xSmall),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPanelaBrown.withAlpha(
                                  20,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppRadius.small,
                                ),
                              ),
                              child: Icon(
                                _iconForStage(stage),
                                size: 28,
                                color: AppColors.primaryPanelaBrown,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.small),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _stageName(stage),
                                    style: textTheme.headlineSmall?.copyWith(
                                      color: AppColors.primaryPanelaBrown,
                                    ),
                                  ),
                                  Text(
                                    _stageSubtitle(stage),
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.textDark.withAlpha(150),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 14,
                              color: AppColors.textDark.withAlpha(100),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForStage(int stage) {
    switch (stage) {
      case 1:
        return AppIcons.deliversSupplies;
      case 2:
        return AppIcons.collect;
      case 3:
        return AppIcons.weighing;
      case 4:
        return AppIcons.pickUpSupplies;
      case 5:
        return AppIcons.summarize;
      default:
        return Icons.help;
    }
  }

  String _stageName(int stage) {
    switch (stage) {
      case 1:
        return 'Entrega';
      case 2:
        return 'Cargue';
      case 3:
        return 'Pesado';
      case 4:
        return 'Recogida molienda';
      case 5:
        return 'Liquidación';
      default:
        return 'No encontrado';
    }
  }

  String _stageSubtitle(int stage) {
    switch (stage) {
      case 1:
        return 'Editar suministros enviados a la molienda';
      case 2:
        return 'Registrar canastillas recogidas en molienda';
      case 3:
        return 'Registrar el peso de las canastillas';
      case 4:
        return 'Registrar suministros vueltos por la molienda';
      case 5:
        return 'Resumen del proyecto y registro de panela';
      default:
        return 'No encontrado';
    }
  }
}
