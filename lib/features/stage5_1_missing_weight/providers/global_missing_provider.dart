import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

// 2) Provider que agrupa Stage2 + Stage3 y calcula los totales
@riverpod
Stage3GlobalSummary stage3GlobalSummary(Ref ref, String projectId) {
  // Trae todas las cargas del proyecto
  final loads2 = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId);

  // Trae todos los registros de pesaje del proyecto
  final entries3 = ref
      .watch(syncStage3ProjectsProvider)
      .where((e) => e.projectId == projectId);

  int expectedCount = 0;
  double expectedWeight = 0;
  int registeredCount = 0;
  double registeredWeight = 0;

  for (final load in loads2) {
    // 2.1) Suma lo esperado según Stage 2
    expectedCount += load.baskets.count;
    expectedWeight += load.baskets.count * load.baskets.realWeight;

    // 2.2) Busca el registro de Stage 3 correspondiente
    final entry = entries3.firstWhereOrNull((e) => e.stage2LoadId == load.id);
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
