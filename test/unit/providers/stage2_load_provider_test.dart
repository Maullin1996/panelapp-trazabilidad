import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/domain/repositories/stage2_repository.dart';
import 'package:registro_panela/features/stage2_load/domain/usecases/get_stage2_load.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_load_provider.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_usecases_provider.dart';

class _FakeStage2Repository implements Stage2Repository {
  _FakeStage2Repository(this._data);

  List<Stage2LoadData> _data;

  @override
  Future<List<Stage2LoadData>> getAll() async => _data;

  @override
  Future<void> create(Stage2LoadData data) async {}

  @override
  Future<void> update(Stage2LoadData data) async {}

  @override
  Future<void> delete(String id) async {}
}

void main() {
  test('Stage2Load builds from usecase data', () async {
    final initial = [
      Stage2LoadData(
        id: 'a',
        projectId: 'p1',
        date: DateTime(2024, 1, 1),
        baskets: const BasketLoadData(
          referenceWeight: 10,
          count: 2,
          realWeight: 12,
        ),
      ),
    ];

    final repo = _FakeStage2Repository(initial);
    final container = ProviderContainer(
      overrides: [
        getStage2LoadsProvider.overrideWithValue(GetStage2Load(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage2LoadProvider.future);
    expect(value, initial);
  });

  test('Stage2Load supports optimistic updates', () async {
    final initial = [
      Stage2LoadData(
        id: 'a',
        projectId: 'p1',
        date: DateTime(2024, 1, 1),
        baskets: const BasketLoadData(
          referenceWeight: 10,
          count: 2,
          realWeight: 12,
        ),
      ),
      Stage2LoadData(
        id: 'b',
        projectId: 'p2',
        date: DateTime(2024, 1, 2),
        baskets: const BasketLoadData(
          referenceWeight: 8,
          count: 1,
          realWeight: 9,
        ),
      ),
    ];

    final repo = _FakeStage2Repository(initial);
    final container = ProviderContainer(
      overrides: [
        getStage2LoadsProvider.overrideWithValue(GetStage2Load(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage2LoadProvider.notifier);
    await container.read(stage2LoadProvider.future);

    final updated = initial[0].copyWith(
      baskets: initial[0].baskets.copyWith(realWeight: 20),
    );
    notifier.addProjectOptimistic(updated);

    final afterUpdate = container.read(stage2LoadProvider).requireValue;
    expect(afterUpdate.firstWhere((e) => e.id == 'a').baskets.realWeight, 20);

    notifier.removeProjectOptimistic('b');
    final afterRemove = container.read(stage2LoadProvider).requireValue;
    expect(afterRemove.any((e) => e.id == 'b'), false);
  });
}