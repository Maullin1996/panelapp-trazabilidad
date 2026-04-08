import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_project_by_id_provider.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_ui_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/missing_gavera.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/helper/money_format.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/widgets/form_total_to_pay.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/global_missing_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_usecases_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/sync_stage51_payments_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';
import 'package:registro_panela/shared/widgets/icon_decoration.dart';

class Stage5MissingWeight extends ConsumerStatefulWidget {
  final String projectId;
  const Stage5MissingWeight({super.key, required this.projectId});

  @override
  ConsumerState<Stage5MissingWeight> createState() =>
      _Stage5MissingWeightState();
}

class _Stage5MissingWeightState extends ConsumerState<Stage5MissingWeight> {
  bool editInstallment = false;
  final scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary3 = ref.watch(stage3GlobalSummaryProvider(widget.projectId));
    final project = ref.watch(stage1ProjectByIdProvider(widget.projectId));
    final returns = ref.watch(stage4UiProvider(widget.projectId));
    final textTheme = TextTheme.of(context);

    if (project == null) {
      return const Scaffold(
        body: Center(child: Text('Proyecto no encontrado')),
      );
    }

    final missingLimeJars = project.limeJars - returns.returnedLimeJars;
    final missingPreservativesJars =
        project.preservativesJars - returns.returnedPreservativesJars;
    final missingBaskets = project.basketsQuantity - returns.returnedBaskets;

    final missingGaveras = <MissingGavera>[];
    final returnedByWeight = {
      for (final ret in returns.returnedGaveras) ret.referenceWeight: ret,
    };
    for (final sent in project.gaveras) {
      final ret = returnedByWeight[sent.referenceWeight];
      final returnedQty = ret?.quantity ?? 0;
      final diff = sent.quantity - returnedQty;
      if (diff != 0) {
        missingGaveras.add(
          MissingGavera(count: diff, referenceWeight: sent.referenceWeight),
        );
      }
    }

    final hasMissing =
        missingGaveras.isNotEmpty ||
        missingLimeJars != 0 ||
        missingPreservativesJars != 0 ||
        missingBaskets != 0 ||
        summary3.totalMissingWeight != 0 ||
        summary3.totalMissingCount != 0;

    final allInstallments = ref.watch(syncStage51PaymentsProvider);
    final installments = allInstallments
        .where((e) => e.projectId == widget.projectId)
        .toList();

    // Progreso de canastillas registradas
    final double progressRatio = summary3.totalExpectedCount > 0
        ? (summary3.totalRegisteredCount / summary3.totalExpectedCount).clamp(
            0.0,
            1.0,
          )
        : 0.0;
    final double progressPercent = progressRatio * 100;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: AppSpacing.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Métricas rápidas en grid 2×1 ──
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    label: 'Canastillas',
                    value:
                        '${summary3.totalRegisteredCount}/${summary3.totalExpectedCount}',
                    unit: 'registradas',
                  ),
                ),
                const SizedBox(width: AppSpacing.xSmall),
                Expanded(
                  child: _MetricCard(
                    label: 'Peso registrado',
                    value: summary3.totalRegisteredWeight.toStringAsFixed(0),
                    unit:
                        'de ${summary3.totalExpectedWeight.toStringAsFixed(0)} kg',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xSmall),

            // ── Barra de progreso ──
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.small),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progressRatio,
                        minHeight: 5,
                        backgroundColor: Colors.black12,
                        color: AppColors.accepted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Moliendas registradas',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '${progressPercent.toStringAsFixed(1)}%',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Faltantes ──
            if (hasMissing) ...[
              const SizedBox(height: AppSpacing.xSmall),
              Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                  bottom: AppSpacing.xSmall,
                ),
                child: Text(
                  'FALTANTES',
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.1,
                    color: Colors.grey,
                  ),
                ),
              ),
              CustomCard(
                isSelected: AppColors.error.withAlpha(30),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...missingGaveras.map(
                        (m) => _AlertRow(
                          label: 'Gaveras ${m.referenceWeight} g',
                          value: '${m.count} unid.',
                          icon: Icons.storage,
                          iconColor: AppColors.error,
                        ),
                      ),
                      if (missingPreservativesJars != 0)
                        _AlertRow(
                          label: 'Tarros conservantes',
                          value: '$missingPreservativesJars unid.',
                          icon: Icons.local_drink_rounded,
                          iconColor: AppColors.error,
                        ),
                      if (missingLimeJars != 0)
                        _AlertRow(
                          label: 'Tarros cal',
                          value: '$missingLimeJars unid.',
                          icon: Icons.local_drink_rounded,
                          iconColor: AppColors.error,
                        ),
                      if (missingBaskets != 0)
                        _AlertRow(
                          label: 'Canastillas',
                          value: '$missingBaskets unid.',
                          icon: Icons.priority_high,
                          iconColor: AppColors.error,
                        ),
                      if (summary3.totalMissingWeight != 0)
                        _AlertRow(
                          label: 'Peso faltante',
                          value:
                              '${summary3.totalMissingWeight.toStringAsFixed(2)} kg',
                          icon: Icons.monitor_weight_outlined,
                          iconColor: AppColors.alert,
                        ),
                    ],
                  ),
                ),
              ),
            ],

            // ── Abonos realizados ──
            if (installments.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xSmall),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 6),
                      child: Text(
                        'ABONOS REALIZADOS',
                        style: textTheme.labelSmall?.copyWith(
                          letterSpacing: 1.1,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('stage5-missing-weight-edit-button'),
                    onPressed: () =>
                        setState(() => editInstallment = !editInstallment),
                    icon: Icon(
                      editInstallment ? Icons.check : Icons.edit,
                      size: 16,
                    ),
                    label: Text(editInstallment ? 'Listo' : 'Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      textStyle: textTheme.bodySmall,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ),
              CustomCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.small),
                  child: Column(
                    children: installments.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            IconDecoration(
                              icon: Icons.attach_money,
                              backgroundColor: AppColors.accepted,
                              iconColor: AppColors.accepted,
                            ),

                            const SizedBox(width: AppSpacing.xSmall),
                            Expanded(
                              child: Text(
                                DateFormat.yMd().format(e.date),
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '\$ ${moneyFormat(e.amount)}',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (editInstallment) ...[
                              const SizedBox(width: 4),
                              SizedBox(
                                width: 32,
                                height: 32,
                                child: IconButton(
                                  key: const Key(
                                    'stage5-missing-weight-delete-button',
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () async {
                                    final deleteUseCase = ref.read(
                                      deleteStage51DataProvider,
                                    );
                                    await deleteUseCase(e.id);
                                  },
                                  icon: const Icon(Icons.close, size: 16),
                                  color: AppColors.error,
                                  style: IconButton.styleFrom(
                                    backgroundColor: AppColors.error.withAlpha(
                                      30,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xSmall),

            // ── Formulario precio / abono ──
            FormTotalToPay(
              projectId: widget.projectId,
              totalRegisteredWeight: summary3.totalRegisteredWeight,
              onPriceCalculated: () {
                scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widgets privados ──────────────────────────────────────────────────────────

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.small),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(unit, style: textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _AlertRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          IconDecoration(icon: icon, iconColor: iconColor),
          const SizedBox(width: AppSpacing.xSmall),
          Expanded(
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF791F1F),
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: const Color(0xFF501313),
            ),
          ),
        ],
      ),
    );
  }
}
