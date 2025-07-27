import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/providers/providers.dart';
import 'package:registro_panela/features/stage5_summary/domain/stage5_summary_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_summary_provider.g.dart';

@riverpod
List<Stage5SummaryDay> stage5Summary(Ref ref, String projectId) {
  final loads = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId);

  // 1) Agrupar por fecha
  final Map<DateTime, Map<String, int>> temp = {};

  for (final load in loads) {
    // normaliza la fecha (sin hora)
    final day = DateTime(load.date.year, load.date.month, load.date.day);

    temp.putIfAbsent(day, () => {});
    // clave única por combinación gav+real
    final key = '${load.baskets.referenceWeight}|${load.baskets.realWeight}';
    temp[day]![key] = (temp[day]![key] ?? 0) + load.baskets.count;
  }

  // 2) Convertir a lista de Stage5SummaryDay
  final result = <Stage5SummaryDay>[];
  temp.forEach((day, mapByKey) {
    final items = mapByKey.entries.map((e) {
      final parts = e.key.split('|');
      return Stage5SummaryItem(
        gaveraWeight: double.parse(parts[0]),
        realWeight: double.parse(parts[1]),
        totalCount: e.value,
      );
    }).toList();

    // opcional: ordenar items por realWeight o gaveraWeight
    items.sort((a, b) => a.realWeight.compareTo(b.realWeight));

    result.add(Stage5SummaryDay(date: day, items: items));
  });

  // opcional: ordenar días cronológicamente
  result.sort((a, b) => a.date.compareTo(b.date));

  return result;
}
