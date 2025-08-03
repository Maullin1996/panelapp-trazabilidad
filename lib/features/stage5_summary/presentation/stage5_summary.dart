import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:registro_panela/features/stage5_summary/providers/stage5_global_summary_provider.dart';
import 'package:registro_panela/features/stage5_summary/providers/stage5_summary_provider.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

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
            appBar: AppBar(
              title: Text(
                'Resumen de cargues',
                style: textTheme.headlineMedium,
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.small,
                AppSpacing.small,
                AppSpacing.small,
                AppSpacing.smallMedium,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // POR DÍA
                  SingleChildScrollView(
                    scrollDirection: Axis
                        .horizontal, // habilita scroll si se sale de pantalla
                    child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text('Fecha', style: textTheme.headlineSmall),
                        ),
                        DataColumn(
                          label: Text(
                            'Canastillas',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Peso real (kg)',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Gavera (g)',
                            style: textTheme.headlineSmall,
                          ),
                        ),
                      ],
                      rows: summaryByDay.expand((day) {
                        final fecha = DateFormat.yMd().format(day.date);
                        return day.items.map((it) {
                          return DataRow(
                            cells: [
                              DataCell(Text(fecha, style: textTheme.bodyLarge)),
                              DataCell(
                                Text(
                                  '${it.totalCount}',
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                              DataCell(
                                Text(
                                  it.realWeight.toStringAsFixed(0),
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                              DataCell(
                                Text(
                                  it.gaveraWeight.toStringAsFixed(0),
                                  style: textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          );
                        });
                      }).toList(),
                    ),
                  ),

                  // TOTAL GLOBAL
                  const SizedBox(height: AppSpacing.smallLarge),
                  Center(
                    child: Text(
                      'Total canastillas',
                      style: textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  ...globalSummary.map((it) {
                    return Center(
                      child: Text(
                        '${it.totalCount} canastillas de ${it.realWeight.toStringAsFixed(0)} kg – gavera ${it.gaveraWeight.toStringAsFixed(0)}',
                        style: textTheme.bodyLarge,
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
  }
}
