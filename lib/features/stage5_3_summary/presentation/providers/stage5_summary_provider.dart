import '../../../stage2_load/presentation/providers/providers.dart';
import '../../../stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import '../../domain/stage5_summary_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_summary_provider.g.dart';

@riverpod
List<Stage5SummaryDay> stage5Summary(Ref ref, String projectId) {
  final loads = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId)
      .toList();

  // Indexamos stage3 por stage2LoadId para O(1)
  final entries3ByLoadId = {
    for (final e
        in ref
            .watch(syncStage3ProjectsProvider)
            .where((e) => e.projectId == projectId))
      e.stage2LoadId: e,
  };

  // 1) Agrupar por fecha
  final Map<DateTime, Map<String, _Accum>> temp = {};

  for (final load in loads) {
    final day = DateTime(load.date.year, load.date.month, load.date.day);
    temp.putIfAbsent(day, () => {});

    // clave única por peso de gavera
    final key = '${load.baskets.referenceWeight}';

    final entry3 = entries3ByLoadId[load.id];
    final registeredWeight =
        entry3?.baskets.fold<double>(0.0, (s, b) => s + b.realWeight) ?? 0.0;

    final prev = temp[day]![key] ?? _Accum(0, 0.0);
    temp[day]![key] = _Accum(
      prev.count + load.baskets.count,
      prev.weight + registeredWeight,
    );
  }

  // 2) Convertir a lista de Stage5SummaryDay
  final result = <Stage5SummaryDay>[];
  temp.forEach((day, mapByKey) {
    final items = mapByKey.entries.map((e) {
      return Stage5SummaryItem(
        gaveraWeight: double.parse(e.key),
        realWeight: e.value.weight,
        totalCount: e.value.count,
      );
    }).toList();

    items.sort((a, b) => a.gaveraWeight.compareTo(b.gaveraWeight));
    result.add(Stage5SummaryDay(date: day, items: items));
  });

  result.sort((a, b) => a.date.compareTo(b.date));
  return result;
}

// Clase auxiliar para acumular en el Map
class _Accum {
  final int count;
  final double weight;
  const _Accum(this.count, this.weight);
}
