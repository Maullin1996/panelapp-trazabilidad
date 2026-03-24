import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/helpers/summary_calculus.dart';

void main() {
  test('stage3PageSummaryCalculus computes totals and missing values', () {
    final stage2 = Stage2LoadData(
      id: 's2',
      projectId: 'p1',
      date: DateTime(2024, 1, 1),
      baskets: const BasketLoadData(
        referenceWeight: 10,
        count: 5,
        realWeight: 10,
      ),
    );

    final stage3 = Stage3FormData(
      id: 's3',
      projectId: 'p1',
      stage2LoadId: 's2',
      date: DateTime(2024, 1, 2),
      baskets: const [
        BasketWeighData(
          id: 'b1',
          sequence: 1,
          referenceWeight: 10,
          realWeight: 9,
          quality: BasketQuality.regular,
          photoPath: 'path',
        ),
        BasketWeighData(
          id: 'b2',
          sequence: 2,
          referenceWeight: 10,
          realWeight: 8,
          quality: BasketQuality.buena,
          photoPath: 'path',
        ),
      ],
    );

    final summary = stage3PageSummaryCalculus(stage2, stage3);

    expect(summary.totalBaskets, 5);
    expect(summary.totalRefKg, 50);
    expect(summary.regCount, 2);
    expect(summary.regWeight, 17);
    expect(summary.missingCount, 3);
    expect(summary.missingWeight, 33);
  });

  test('stage3PageSummaryCalculus clamps missing weight to zero', () {
    final stage2 = Stage2LoadData(
      id: 's2',
      projectId: 'p1',
      date: DateTime(2024, 1, 1),
      baskets: const BasketLoadData(
        referenceWeight: 10,
        count: 1,
        realWeight: 10,
      ),
    );

    final stage3 = Stage3FormData(
      id: 's3',
      projectId: 'p1',
      stage2LoadId: 's2',
      date: DateTime(2024, 1, 2),
      baskets: const [
        BasketWeighData(
          id: 'b1',
          sequence: 1,
          referenceWeight: 10,
          realWeight: 12,
          quality: BasketQuality.extra,
          photoPath: 'path',
        ),
      ],
    );

    final summary = stage3PageSummaryCalculus(stage2, stage3);
    expect(summary.missingWeight, 0);
  });

  test('clampZero returns 0 for negatives', () {
    expect(clampZero(-0.1), 0);
    expect(clampZero(2.5), 2.5);
  });
}