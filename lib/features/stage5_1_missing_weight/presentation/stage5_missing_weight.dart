import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/features/stage1_delivery/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage4_recollection/providers/stage4_ui_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/missing_gavera.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/widgets/form_total_to_pay.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/global_missing_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage51_notifier_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage51_usecases_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/custom_rich_text.dart';

class Stage5MissingWeight extends ConsumerStatefulWidget {
  final String projectId;
  const Stage5MissingWeight({super.key, required this.projectId});

  @override
  ConsumerState<Stage5MissingWeight> createState() =>
      _Stage5MissingWeightState();
}

class _Stage5MissingWeightState extends ConsumerState<Stage5MissingWeight> {
  bool editInstallment = false;
  @override
  Widget build(BuildContext context) {
    final summary3 = ref.watch(stage3GlobalSummaryProvider(widget.projectId));

    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId))!;

    final returns = ref.watch(stage4UiProvider(widget.projectId));

    final textTheme = TextTheme.of(context);

    final missingLimeJars = project.limeJars - returns.returnedLimeJars;

    final missingPreservativesJars =
        project.preservativesJars - returns.returnedPreservativesJars;

    final missingGaveras = <MissingGavera>[];
    for (
      int i = 0;
      i < project.gaveras.length && i < returns.returnedGaveras.length;
      i++
    ) {
      final sent = project.gaveras[i];
      final ret = returns.returnedGaveras[i];
      final diff = sent.quantity - ret.quantity;
      if (diff != 0) {
        missingGaveras.add(
          MissingGavera(count: diff, referenceWeight: ret.referenceWeight),
        );
      }
    }

    final hasMissingGaveras = missingGaveras.isNotEmpty;

    final installments = ref.watch(syncStage51PaymentsProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: AppSpacing.medium),
        child: Column(
          children: [
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Column(
                  children: [
                    Text(
                      'Total registrado en moliendas',
                      maxLines: 2,
                      style: textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.smallLarge),
                    CustomRichText(
                      icon: Icons.shopping_basket,
                      iconColor: AppColors.register,
                      firstText: 'Canastillas esperadas: ',
                      secondText: '${summary3.totalExpectedCount}',
                    ),
                    CustomRichText(
                      icon: Icons.scale,
                      iconColor: AppColors.weight,
                      firstText: 'Peso esperado: ',
                      secondText:
                          '${summary3.totalExpectedWeight.toStringAsFixed(2)} kg',
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
                    Text(
                      'Total registrado en bodega',
                      style: textTheme.headlineLarge,
                    ),
                    const SizedBox(height: AppSpacing.smallLarge),
                    CustomRichText(
                      icon: Icons.all_inbox_rounded,
                      iconColor: AppColors.register,
                      firstText: 'Registradas: ',
                      secondText:
                          '${summary3.totalRegisteredCount} Canastillas',
                    ),
                    CustomRichText(
                      icon: Icons.check_box,
                      iconColor: AppColors.accepted,
                      firstText: 'Peso registrado: ',
                      secondText:
                          '${summary3.totalRegisteredWeight.toStringAsFixed(2)} kg',
                    ),
                  ],
                ),
              ),
            ),

            if (summary3.totalMissingCount != 0 ||
                summary3.totalMissingWeight != 0 ||
                missingLimeJars != 0 ||
                missingPreservativesJars != 0 ||
                hasMissingGaveras)
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Total Faltante',
                          style: textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.smallLarge),
                      ...missingGaveras.map((m) {
                        return CustomRichText(
                          icon: Icons.storage,
                          iconColor: AppColors.weight,
                          firstText: 'Falta: ',
                          secondText:
                              '${m.count} gaveras de ${m.referenceWeight}g',
                        );
                      }),
                      if (missingPreservativesJars != 0)
                        CustomRichText(
                          firstText: 'Falta: ',
                          secondText:
                              '$missingPreservativesJars Tarros conservantes',
                          icon: Icons.local_drink_rounded,
                          iconColor: AppColors.accepted,
                        ),
                      if (missingLimeJars != 0)
                        CustomRichText(
                          firstText: 'Falta: ',
                          secondText: '$missingLimeJars Tarros cal',
                          icon: Icons.local_drink_rounded,
                          iconColor: AppColors.accentLightPanela,
                        ),
                      if (summary3.totalMissingCount != 0)
                        CustomRichText(
                          firstText: 'Faltan: ',
                          secondText:
                              '${summary3.totalMissingCount} Canastillas',
                          icon: Icons.priority_high,
                          iconColor: AppColors.error,
                        ),
                      if (summary3.totalMissingWeight != 0)
                        CustomRichText(
                          firstText: 'Peso Faltante: ',
                          secondText:
                              '${summary3.totalMissingWeight.toStringAsFixed(2)} kg',
                          icon: Icons.warning,
                          iconColor: AppColors.alert,
                        ),
                    ],
                  ),
                ),
              ),
            if (installments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.smallLarge,
                      top: AppSpacing.smallMedium,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Abonos realizados',
                            style: textTheme.headlineLarge,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() => editInstallment = !editInstallment);
                          },
                          icon: Icon(
                            editInstallment ? Icons.cancel : Icons.edit,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomCard(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(AppSpacing.smallLarge),
                      child: Column(
                        children: [
                          ...installments.map(
                            (e) => Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${DateFormat.yMd().format(e.date)}:',
                                    style: textTheme.headlineMedium,
                                  ),
                                ),
                                Text(
                                  '\$ ${moneyFormat(e.amount)}',
                                  style: textTheme.bodyLarge,
                                ),
                                if (editInstallment)
                                  IconButton(
                                    onPressed: () async {
                                      final deleteUseCase = ref.read(
                                        deleteStage51DataProvider,
                                      );
                                      await deleteUseCase(e.id);
                                      ref
                                          .read(
                                            stage51NotifierProvider.notifier,
                                          )
                                          .refresh();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: AppColors.error,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            FormTotalToPay(
              projectId: widget.projectId,
              totalRegisteredWeight: summary3.totalRegisteredWeight,
            ),
          ],
        ),
      ),
    );
  }
}
