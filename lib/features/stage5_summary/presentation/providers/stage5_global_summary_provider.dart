import 'package:registro_panela/features/stage5_summary/domain/stage5_summary_item.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_summary_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_global_summary_provider.g.dart';

@riverpod
List<Stage5SummaryItem> stage5GlobalSummary(Ref ref, String projectId) {
  final days = ref.watch(stage5SummaryProvider(projectId));
  final Map<double, _Accum> agg = {};

  for (final day in days) {
    for (final item in day.items) {
      final prev = agg[item.gaveraWeight] ?? const _Accum(0, 0.0);
      agg[item.gaveraWeight] = _Accum(
        prev.count + item.totalCount,
        prev.weight + item.realWeight,
      );
    }
  }

  return agg.entries.map((e) {
    return Stage5SummaryItem(
      gaveraWeight: e.key,
      realWeight: e.value.weight,
      totalCount: e.value.count,
    );
  }).toList()..sort((a, b) => a.gaveraWeight.compareTo(b.gaveraWeight));
}

class _Accum {
  final int count;
  final double weight;
  const _Accum(this.count, this.weight);
}
