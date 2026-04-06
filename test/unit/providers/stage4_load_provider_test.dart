import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domin/repositories/stage4_repository.dart';
import 'package:registro_panela/features/stage4_recollection/domin/usecases/get_stage4_loads.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_load_provider.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_usecases_provider.dart';

class _FakeStage4Repository implements Stage4Repository {
  _FakeStage4Repository(this._data);

  final List<Stage4FormData> _data;

  @override
  Future<List<Stage4FormData>> getAll() async => _data;

  @override
  Future<void> create(Stage4FormData data) async {}

  @override
  Future<void> update(Stage4FormData data) async {}
}

Stage4FormData _stage4(String id, String projectId) {
  return Stage4FormData(
    id: id,
    projectId: projectId,
    date: DateTime(2024, 1, 1),
    returnedGaveras: const [ReturnedGaveras(quantity: 1, referenceWeight: 10)],
    returnedBaskets: 3,
    returnedPreservativesJars: 1,
    returnedLimeJars: 2,
  );
}

void main() {
  test('Stage4Load builds from usecase data', () async {
    final initial = [_stage4('a', 'p1')];
    final repo = _FakeStage4Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage4DataProvider.overrideWithValue(GetStage4Loads(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage4LoadProvider.future);
    expect(value, initial);
  });

  test('Stage4Load optimistic add/update', () async {
    final initial = [_stage4('a', 'p1')];
    final repo = _FakeStage4Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage4DataProvider.overrideWithValue(GetStage4Loads(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage4LoadProvider.notifier);
    await container.read(stage4LoadProvider.future);

    final added = _stage4('b', 'p1');
    notifier.addDataOptimistic(added);
    final afterAdd = container.read(stage4LoadProvider).requireValue;
    expect(afterAdd.any((e) => e.id == 'b'), true);

    final updated = _stage4('a', 'p1').copyWith(returnedBaskets: 10);
    notifier.updateProjectOptimistic(updated);
    final afterUpdate = container.read(stage4LoadProvider).requireValue;
    expect(afterUpdate.first.returnedBaskets, 10);
  });
}
