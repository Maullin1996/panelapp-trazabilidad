// stage5_invoice_summary_provider.dart
import 'package:registro_panela/features/stage2_load/presentation/providers/sync_stage2_loads_provider.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_invoice_summary_provider.g.dart';

class InvoiceQualitySummary {
  final Map<BasketQuality, double> kgByQuality; // kg reales por calidad
  final double totalKg;

  const InvoiceQualitySummary({
    required this.kgByQuality,
    required this.totalKg,
  });
}

@riverpod
InvoiceQualitySummary stage5InvoiceSummary(Ref ref, String projectId) {
  final loads2 = ref
      .watch(syncStage2ProjectsProvider)
      .where((l) => l.projectId == projectId)
      .toList();

  final entries3ByLoadId = {
    for (final e
        in ref
            .watch(syncStage3ProjectsProvider)
            .where((e) => e.projectId == projectId))
      e.stage2LoadId: e,
  };

  final kgByQuality = <BasketQuality, double>{};

  for (final load in loads2) {
    final entry = entries3ByLoadId[load.id];
    if (entry == null) continue;

    for (final basket in entry.baskets) {
      kgByQuality[basket.quality] =
          (kgByQuality[basket.quality] ?? 0.0) + basket.realWeight;
    }
  }

  final totalKg = kgByQuality.values.fold(0.0, (s, v) => s + v);

  return InvoiceQualitySummary(kgByQuality: kgByQuality, totalKg: totalKg);
}
