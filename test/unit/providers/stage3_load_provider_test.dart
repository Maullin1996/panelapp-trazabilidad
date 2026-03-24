import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';
import 'package:registro_panela/features/stage3_weigh/domain/usecase/get_stage3_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_usecases_provider.dart';

class _FakeStage3Repository implements Stage3Repository {
  _FakeStage3Repository(this._data);

  List<Stage3FormData> _data;

  @override
  Future<List<Stage3FormData>> getAll() async => _data;

  @override
  Future<void> create(Stage3FormData data) async {}

  @override
  Future<void> update(Stage3FormData data) async {}

  @override
  Future<void> delete(String id) async {}
}

Stage3FormData _buildStage3({required String id, required String loadId}) {
  return Stage3FormData(
    id: id,
    projectId: 'p1',
    stage2LoadId: loadId,
    date: DateTime(2024, 1, 1),
    baskets: const [
      BasketWeighData(
        id: 'b1',
        sequence: 1,
        referenceWeight: 10,
        realWeight: 9,
        quality: BasketQuality.regular,
        photoPath: 'path',
      ),
    ],
  );
}

void main() {
  test('Stage3Load builds from usecase data', () async {
    final initial = [_buildStage3(id: 'a', loadId: 'l2')];

    final repo = _FakeStage3Repository(initial);
    final container = ProviderContainer(
      overrides: [
        getStage3LoadsProvider.overrideWithValue(GetStage3Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage3LoadProvider.future);
    expect(value, initial);
  });

  test('Stage3Load supports optimistic updates', () async {
    final initial = [
      _buildStage3(id: 'a', loadId: 'l2'),
      _buildStage3(id: 'b', loadId: 'l3'),
    ];

    final repo = _FakeStage3Repository(initial);
    final container = ProviderContainer(
      overrides: [
        getStage3LoadsProvider.overrideWithValue(GetStage3Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage3LoadProvider.notifier);
    await container.read(stage3LoadProvider.future);

    final updated = initial[0].copyWith(
      baskets: [
        initial[0].baskets.first.copyWith(realWeight: 12),
      ],
    );
    notifier.addProjectOptimistic(updated);

    final afterUpdate = container.read(stage3LoadProvider).requireValue;
    expect(afterUpdate.firstWhere((e) => e.id == 'a').baskets.first.realWeight, 12);

    notifier.removeProjectOptimistic('b');
    final afterRemove = container.read(stage3LoadProvider).requireValue;
    expect(afterRemove.any((e) => e.id == 'b'), false);
  });
}