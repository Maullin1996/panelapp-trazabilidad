import 'package:registro_panela/features/stage5_summary/domain/stage5_summary_item.dart';
import 'package:registro_panela/features/stage5_summary/presentation/providers/stage5_summary_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_global_summary_provider.g.dart';

@riverpod
List<Stage5SummaryItem> stage5GlobalSummary(Ref ref, String projectId) {
  final days = ref.watch(stage5SummaryProvider(projectId));
  final Map<String, int> agg = {};

  for (final day in days) {
    for (final item in day.items) {
      final key = '${item.gaveraWeight}|${item.realWeight}';
      agg[key] = (agg[key] ?? 0) + item.totalCount;
    }
  }

  return agg.entries.map((e) {
    final p = e.key.split('|');
    return Stage5SummaryItem(
      gaveraWeight: double.parse(p[0]),
      realWeight: double.parse(p[1]),
      totalCount: e.value,
    );
  }).toList()..sort((a, b) => a.realWeight.compareTo(b.realWeight));
}
