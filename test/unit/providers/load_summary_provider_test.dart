import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/stage2_loads_by_id_provider.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/inputs_math_provider.dart';
import 'package:registro_panela/features/stage3_weigh/providers/sync_stage3_loads_provider.dart';

void main() {
  test('loadSummary returns zeros when stage2 load is missing', () {
    final container = ProviderContainer(
      overrides: [
        stage2LoadsByIdProvider.overrideWith((ref, id) => null),
        syncStage3ProjectsProvider.overrideWith((ref) => const []),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(loadSummaryProvider('missing'));

    expect(summary.totalRefkg, 0);
    expect(summary.regCount, 0);
    expect(summary.regWeight, 0);
    expect(summary.missingCount, 0);
    expect(summary.missingWeight, 0);
  });

  test('loadSummary computes totals and missing values from providers', () {
    final stage2 = Stage2LoadData(
      id: 'l2',
      projectId: 'p1',
      date: DateTime(2024, 1, 1),
      baskets: const BasketLoadData(
        referenceWeight: 10,
        count: 4,
        realWeight: 12,
      ),
    );

    final stage3 = Stage3FormData(
      id: 's3',
      projectId: 'p1',
      stage2LoadId: 'l2',
      date: DateTime(2024, 1, 2),
      baskets: const [
        BasketWeighData(
          id: 'b1',
          sequence: 1,
          referenceWeight: 10,
          realWeight: 11,
          quality: BasketQuality.regular,
          photoPath: 'path',
        ),
        BasketWeighData(
          id: 'b2',
          sequence: 2,
          referenceWeight: 10,
          realWeight: 9,
          quality: BasketQuality.buena,
          photoPath: 'path',
        ),
      ],
    );

    final container = ProviderContainer(
      overrides: [
        stage2LoadsByIdProvider.overrideWith((ref, id) => stage2),
        syncStage3ProjectsProvider.overrideWith((ref) => [stage3]),
      ],
    );
    addTearDown(container.dispose);

    final summary = container.read(loadSummaryProvider('l2'));

    expect(summary.totalRefkg, 48);
    expect(summary.regCount, 2);
    expect(summary.regWeight, 20);
    expect(summary.missingCount, 2);
    expect(summary.missingWeight, 28);
  });
}
