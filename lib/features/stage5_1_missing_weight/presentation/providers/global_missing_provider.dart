import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_missing_provider.g.dart';

// 1) Modelo que devuelve el resumen global
class Stage3GlobalSummary {
  final int totalExpectedCount;
  final double totalExpectedWeight;
  final int totalRegisteredCount;
  final double totalRegisteredWeight;
  final int totalMissingCount;
  final double totalMissingWeight;

  const Stage3GlobalSummary({
    required this.totalExpectedCount,
    required this.totalExpectedWeight,
    required this.totalRegisteredCount,
    required this.totalRegisteredWeight,
    required this.totalMissingCount,
    required this.totalMissingWeight,
  });
}

// ✅ Después
@riverpod
Stage3GlobalSummary stage3GlobalSummary(Ref ref, String projectId) {
  final loads2 = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId)
      .toList();

  // Indexamos los registros de Stage3 por stage2LoadId para O(1) lookup
  final entries3ByLoadId = {
    for (final e
        in ref
            .watch(syncStage3ProjectsProvider)
            .where((e) => e.projectId == projectId))
      e.stage2LoadId: e,
  };

  int expectedCount = 0;
  double expectedWeight = 0;
  int registeredCount = 0;
  double registeredWeight = 0;

  for (final load in loads2) {
    expectedCount += load.baskets.count;
    expectedWeight += load.baskets.count * load.baskets.realWeight;

    // O(1) en lugar de firstWhereOrNull que es O(n)
    final entry = entries3ByLoadId[load.id];
    if (entry != null) {
      registeredCount += entry.baskets.length;
      registeredWeight += entry.baskets.fold(
        0.0,
        (sum, b) => sum + b.realWeight,
      );
    }
  }

  final missingCount = expectedCount - registeredCount;
  final missingWeight = expectedWeight - registeredWeight;

  return Stage3GlobalSummary(
    totalExpectedCount: expectedCount,
    totalExpectedWeight: expectedWeight,
    totalRegisteredCount: registeredCount,
    totalRegisteredWeight: registeredWeight,
    totalMissingCount: missingCount,
    totalMissingWeight: missingWeight,
  );
}
