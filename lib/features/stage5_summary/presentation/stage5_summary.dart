import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_global_summary_provider.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_summary_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';
import 'package:registro_panela/shared/widgets/custom_card.dart';

class Stage5Summary extends ConsumerWidget {
  final String projectId;
  const Stage5Summary({required this.projectId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryByDay = ref.watch(stage5SummaryProvider(projectId));
    final globalSummary = ref.watch(stage5GlobalSummaryProvider(projectId));
    final textTheme = TextTheme.of(context);

    return (summaryByDay.isEmpty)
        ? Center(
            child: Text(
              'No ha habido cargues',
              style: textTheme.headlineMedium,
            ),
          )
        : Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.only(top: AppSpacing.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOTAL GLOBAL
                  CustomCard(
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Resumen general',
                            style: textTheme.headlineLarge,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xSmall),
                        ...globalSummary.map((it) {
                          return Center(
                            child: Text(
                              '• ${it.totalCount} canastillas de ${it.realWeight.toStringAsFixed(0)} kg – gavera ${it.gaveraWeight.toStringAsFixed(0)}',
                              style: textTheme.bodyLarge,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.smallLarge),
                  Center(
                    child: Text(
                      'Resumen Diario',
                      style: textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  ...summaryByDay.map((summary) {
                    final formattedDate = DateFormat(
                      "EEEE d 'de' MMMM",
                      'es',
                    ).format(summary.date);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.small,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.smallLarge,
                            ),
                            child: Text(
                              formattedDate,
                              style: textTheme.headlineLarge,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xSmall),
                          CustomCard(
                            child: Column(
                              children: summary.items.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.xSmall,
                                    horizontal: AppSpacing.xSmall,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Canastillas:',
                                            style: textTheme.headlineMedium,
                                          ),
                                          Text(
                                            '${e.totalCount}',
                                            style: textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Peso:',
                                            style: textTheme.headlineMedium,
                                          ),
                                          Text(
                                            '${e.realWeight.toStringAsFixed(1)} kg',
                                            style: textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Gavera usada:',
                                            style: textTheme.headlineMedium,
                                          ),
                                          Text(
                                            '${e.gaveraWeight} g',
                                            style: textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      const Divider(height: 24),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
  }
}
