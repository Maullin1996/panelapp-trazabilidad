import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/inputs_math_provider.dart';

class SummaryCalculus {
  final int totalBaskets;
  final double totalRefKg;
  final int regCount;
  final double regWeight;
  final int missingCount;
  final double missingWeight;

  SummaryCalculus({
    required this.totalBaskets,
    required this.totalRefKg,
    required this.regCount,
    required this.regWeight,
    required this.missingCount,
    required this.missingWeight,
  });
}

SummaryCalculus stage3PageSummaryCalculus(
  Stage2LoadData stage2LoadData,
  Stage3FormData stage3FormData,
) {
  final group = stage2LoadData.baskets;
  final totalBaskets = group.count;
  final totalRefKg = group.realWeight * totalBaskets;

  final regCount = stage3FormData.baskets.length;
  final regWeight = stage3FormData.baskets.fold<double>(
    0,
    (sum, b) => sum + b.realWeight,
  );

  final missingCount = totalBaskets - regCount;
  final missingWeight = clampZero(totalRefKg - regWeight);

  return SummaryCalculus(
    totalBaskets: totalBaskets,
    totalRefKg: totalRefKg,
    regCount: regCount,
    regWeight: regWeight,
    missingCount: missingCount,
    missingWeight: missingWeight,
  );
}
