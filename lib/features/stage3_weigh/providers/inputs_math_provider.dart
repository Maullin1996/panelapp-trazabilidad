import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/providers/providers.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inputs_math_provider.g.dart';

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
LoadSummary loadSummary(Ref ref, String load2Id) {
  final load2 = ref.watch(stage2LoadsByIdProvider(load2Id));

  if (load2 == null) {
    return LoadSummary(
      totalRefkg: 0,
      regCount: 0,
      regWeight: 0,
      missingCount: 0,
      missingWeight: 0,
    );
  }

  final entries3 = ref.watch(syncStage3ProjectsProvider);

  final totalBaskets = load2.baskets.count;
  final refPerBasket = load2.baskets.realWeight;
  final totalRefkg = refPerBasket * totalBaskets;

  final entry = entries3.firstWhereOrNull((e) => e.stage2LoadId == load2Id);

  final regCount = entry?.baskets.length ?? 0;
  final regWeight =
      entry?.baskets.fold<double>(0, (s, b) => s + b.realWeight) ?? 0;

  final missingCount = (totalBaskets - regCount).clamp(0, totalBaskets);
  final missingWeight = (totalRefkg - regWeight).clamp(0, double.infinity);

  return LoadSummary(
    totalRefkg: totalRefkg,
    regCount: regCount,
    regWeight: regWeight,
    missingCount: missingCount,
    missingWeight: missingWeight.toDouble(),
  );
}
