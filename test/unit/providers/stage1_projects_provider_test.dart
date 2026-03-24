import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/domain/repositories/stage1_repository.dart';
import 'package:registro_panela/features/stage1_delivery/domain/usecases/get_stage1_projects.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_projects_provider.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_usecases_provider.dart';

class _FakeStage1Repository implements Stage1Repository {
  _FakeStage1Repository(this._data);

  List<Stage1FormData> _data;

  @override
  Future<List<Stage1FormData>> getAll() async => _data;

  @override
  Future<void> create(Stage1FormData data) async {}

  @override
  Future<void> update(Stage1FormData data) async {}

  @override
  Future<void> delete(String id) async {}
}

Stage1FormData _stage1(String id, String name) {
  return Stage1FormData(
    id: id,
    name: name,
    gaveras: const [GaveraData(quantity: 2, referenceWeight: 10)],
    basketsQuantity: 10,
    preservativesWeight: 1.2,
    preservativesJars: 2,
    limeWeight: 0.5,
    limeJars: 1,
    phone: '123',
    date: DateTime(2024, 1, 1),
    photoPath: null,
  );
}

void main() {
  test('Stage1Projects builds from usecase data', () async {
    final initial = [_stage1('a', 'A')];
    final repo = _FakeStage1Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage1ProjectsProvider.overrideWithValue(GetStage1Projects(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage1ProjectsProvider.future);
    expect(value, initial);
  });

  test('Stage1Projects optimistic add/update/remove', () async {
    final initial = [_stage1('a', 'A'), _stage1('b', 'B')];
    final repo = _FakeStage1Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage1ProjectsProvider.overrideWithValue(GetStage1Projects(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage1ProjectsProvider.notifier);
    await container.read(stage1ProjectsProvider.future);

    final added = _stage1('c', 'C');
    notifier.addProjectOptimistic(added);
    final afterAdd = container.read(stage1ProjectsProvider).requireValue;
    expect(afterAdd.first.id, 'c');

    final updated = _stage1('a', 'A+');
    notifier.updateProjectOptimistic(updated);
    final afterUpdate = container.read(stage1ProjectsProvider).requireValue;
    expect(afterUpdate.firstWhere((e) => e.id == 'a').name, 'A+');

    notifier.removeProjectOptimistic('b');
    final afterRemove = container.read(stage1ProjectsProvider).requireValue;
    expect(afterRemove.any((e) => e.id == 'b'), false);
  });
}