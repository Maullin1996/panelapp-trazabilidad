import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';
import 'package:registro_panela/features/stage5_2_records/domain/usecases/get_stage52_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_load_provider.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_usecases_provider.dart';

class _FakeStage52Repository implements Stage52Repository {
  _FakeStage52Repository(this._data);

  List<Stage52RecordData> _data;

  @override
  Future<List<Stage52RecordData>> getAll() async => _data;

  @override
  Future<void> create(Stage52RecordData data) async {}

  @override
  Future<void> update(Stage52RecordData data) async {}

  @override
  Future<void> delete(String id) async {}
}

Stage52RecordData _record(String id, String projectId) {
  return Stage52RecordData(
    id: id,
    projectId: projectId,
    gaveraWeight: 10,
    panelaWeight: 9,
    unitCount: 2,
    quality: BasketQuality.regular,
    photoPath: 'path',
    date: DateTime(2024, 1, 1),
  );
}

void main() {
  test('Stage52Load builds from usecase data', () async {
    final initial = [_record('a', 'p1')];
    final repo = _FakeStage52Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage52ProjectsProvider.overrideWithValue(GetStage52Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage52LoadProvider.future);
    expect(value, initial);
  });

  test('Stage52Load optimistic add/update/remove', () async {
    final initial = [_record('a', 'p1'), _record('b', 'p1')];
    final repo = _FakeStage52Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage52ProjectsProvider.overrideWithValue(GetStage52Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage52LoadProvider.notifier);
    await container.read(stage52LoadProvider.future);

    notifier.addLoadOptimistic(_record('c', 'p1'));
    final afterAdd = container.read(stage52LoadProvider).requireValue;
    expect(afterAdd.first.id, 'c');

    final updated = _record('a', 'p1').copyWith(unitCount: 99);
    notifier.updateLoadOptimistic(updated);
    final afterUpdate = container.read(stage52LoadProvider).requireValue;
    expect(afterUpdate.firstWhere((e) => e.id == 'a').unitCount, 99);

    notifier.removeProjectOptimistic('b');
    final afterRemove = container.read(stage52LoadProvider).requireValue;
    expect(afterRemove.any((e) => e.id == 'b'), false);
  });
}
