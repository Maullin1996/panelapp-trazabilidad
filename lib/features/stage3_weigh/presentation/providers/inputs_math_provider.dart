import 'package:collection/collection.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inputs_math_provider.g.dart';

class LoadSummary {
  final int totalBaskets;
  final int regCount;
  final int missingCount;
  final Map<BasketQuality, int> countByQuality;

  LoadSummary({
    required this.totalBaskets,
    required this.regCount,
    required this.missingCount,
    required this.countByQuality,
  });
}

@riverpod
LoadSummary loadSummary(Ref ref, String load2Id) {
  final load2 = ref.watch(stage2LoadsByIdProvider(load2Id));

  if (load2 == null) {
    return LoadSummary(
      totalBaskets: 0,
      regCount: 0,
      missingCount: 0,
      countByQuality: {},
    );
  }

  final entries3 = ref.watch(syncStage3ProjectsProvider);
  final entry = entries3.firstWhereOrNull((e) => e.stage2LoadId == load2Id);

  final totalBaskets = load2.baskets.count;
  final regCount = entry?.baskets.length ?? 0;
  final missingCount = (totalBaskets - regCount).clamp(0, totalBaskets);

  final countByQuality = <BasketQuality, int>{};
  for (final b in entry?.baskets ?? []) {
    countByQuality[b.quality] = (countByQuality[b.quality] ?? 0) + 1;
  }

  return LoadSummary(
    totalBaskets: totalBaskets,
    regCount: regCount,
    missingCount: missingCount,
    countByQuality: countByQuality,
  );
}
