import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class LoadSummary {
  final double totalRefkg;
  final int regCount;
  final double regWeight;
  final int missingCount;
  final double missingWeight;

  LoadSummary({
    required this.totalRefkg,
    required this.regCount,
    required this.regWeight,
    required this.missingCount,
    required this.missingWeight,
  });
}

@riverpod
LoadSummary loadSummary(Ref ref, String projectId, int index) {
  final loads2 = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId)
      .toList();
  final entries3 = ref.watch(syncStage3ProjectsProvider);

  final load2 = loads2[index];
  final int totalBaskets = load2.baskets.count;
  final double realWeight = load2.baskets.realWeight;
  final double totalRefkg = totalBaskets * realWeight;
  double total = 0.0;
  final entry = entries3.firstWhereOrNull((e) => e.stage2LoadId == load2.id);
  if (entry != null) {
    total = entry.baskets.fold<double>(0, (sum, b) => sum + b.realWeight);
  }

  final regCount = entry?.baskets.length ?? 0;
  final regWeight = total;
  final missingCount = totalBaskets - regCount;
  final missingWeight = totalRefkg - regWeight;

  return LoadSummary(
    totalRefkg: totalRefkg,
    regCount: regCount,
    regWeight: regWeight,
    missingCount: missingCount,
    missingWeight: missingWeight,
  );
}
