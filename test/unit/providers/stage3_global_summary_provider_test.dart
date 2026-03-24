import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/global_missing_provider.dart';
import 'package:registro_panela/features/stage2_load/providers/sync_stage2_loads_provider.dart';

Stage2LoadData _load2({
  required String id,
  required String projectId,
  required int count,
  required double realWeight,
}) {
  return Stage2LoadData(
    id: id,
    projectId: projectId,
    date: DateTime(2024, 1, 1),
    baskets: BasketLoadData(
      referenceWeight: 10,
      count: count,
      realWeight: realWeight,
    ),
  );
}

Stage3FormData _load3({required String id, required String load2Id, int baskets = 0, double weight = 0}) {
  return Stage3FormData(
    id: id,
    projectId: 'p1',
    stage2LoadId: load2Id,
    date: DateTime(2024, 1, 2),
    baskets: List.generate(
      baskets,
      (i) => BasketWeighData(
        id: 'b$i',
        sequence: i + 1,
        referenceWeight: 10,
        realWeight: weight,
        quality: BasketQuality.regular,
        photoPath: 'path',
      ),
    ),
  );
}

void main() {
  test('stage3GlobalSummary aggregates expected and registered totals', () {
    final loads2 = [
      _load2(id: 'l1', projectId: 'p1', count: 3, realWeight: 12),
      _load2(id: 'l2', projectId: 'p1', count: 2, realWeight: 10),
      _load2(id: 'other', projectId: 'p2', count: 10, realWeight: 10),
    ];

    final loads3 = [
      _load3(id: 's1', load2Id: 'l1', baskets: 2, weight: 11),
      _load3(id: 's2', load2Id: 'l2', baskets: 1, weight: 9),
    ];

    final container = ProviderContainer(
      overrides: [
        syncStage2ProjectsProvider.overrideWith((ref) => loads2),
        syncStage3ProjectsProvider.overrideWith((ref) => loads3),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(stage3GlobalSummaryProvider('p1'));

    expect(summary.totalExpectedCount, 5);
    expect(summary.totalExpectedWeight, 3 * 12 + 2 * 10);
    expect(summary.totalRegisteredCount, 3);
    expect(summary.totalRegisteredWeight, 2 * 11 + 1 * 9);
    expect(summary.totalMissingCount, 2);
    expect(summary.totalMissingWeight, (3 * 12 + 2 * 10) - (2 * 11 + 1 * 9));
  });
}