import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/core/storage/domain/repositories/storage_repository.dart';
import 'package:registro_panela/core/storage/domain/usecases/upload_image.dart';
import 'package:registro_panela/core/storage/application/storage_providers.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';
import 'package:registro_panela/features/stage5_2_records/domain/usecases/create_stage52_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/usecases/update_stage52_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_form_status.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_usecases_provider.dart';

class _FakeStorageRepository implements StorageRepository {
  String? lastPath;
  String? lastLocalPath;

  @override
  Future<String> uploadImage({
    required String path,
    required String localFilePath,
  }) async {
    lastPath = path;
    lastLocalPath = localFilePath;
    return 'http://cdn/$path';
  }
}

class _FakeStage52Repository implements Stage52Repository {
  Stage52RecordData? lastCreated;
  Stage52RecordData? lastUpdated;
  bool shouldThrow = false;

  @override
  Future<void> create(Stage52RecordData data) async {
    if (shouldThrow) throw Exception('create failed');
    lastCreated = data;
  }

  @override
  Future<void> update(Stage52RecordData data) async {
    if (shouldThrow) throw Exception('update failed');
    lastUpdated = data;
  }

  @override
  Future<List<Stage52RecordData>> getAll() async => [];

  @override
  Future<void> delete(String id) async {}
}

Stage52RecordData _record({required String id, required String photoPath}) {
  return Stage52RecordData(
    id: id,
    projectId: 'p1',
    gaveraWeight: 10,
    panelaWeight: 9,
    unitCount: 2,
    quality: BasketQuality.regular,
    photoPath: photoPath,
    date: DateTime(2024, 1, 1),
  );
}

void main() {
  test('Stage52Form uploads local photo and creates new record', () async {
    final storage = _FakeStorageRepository();
    final repo = _FakeStage52Repository();

    final container = ProviderContainer(
      overrides: [
        uploadImageProvider.overrideWithValue(UploadImage(storage)),
        createStage52DataProvider.overrideWithValue(CreateStage52Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final form = container.read(stage52FormProvider.notifier);

    await form.submit(
      data: _record(id: 'a', photoPath: 'local.jpg'),
      isNew: true,
    );

    final state = container.read(stage52FormProvider);
    expect(state.status, Stage52FormStatus.success);
    expect(storage.lastPath, 'stage52_photos/a.jpg');
    expect(storage.lastLocalPath, 'local.jpg');
    expect(repo.lastCreated?.photoPath, startsWith('http://cdn/'));
  });

  test('Stage52Form updates record when isNew is false', () async {
    final repo = _FakeStage52Repository();

    final container = ProviderContainer(
      overrides: [
        updateStage52DataProvider.overrideWithValue(UpdateStage52Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final form = container.read(stage52FormProvider.notifier);

    await form.submit(
      data: _record(id: 'b', photoPath: 'http://cdn/existing.jpg'),
      isNew: false,
    );

    final state = container.read(stage52FormProvider);
    expect(state.status, Stage52FormStatus.success);
    expect(repo.lastUpdated?.id, 'b');
  });

  test('Stage52Form reports error on failure', () async {
    final repo = _FakeStage52Repository()..shouldThrow = true;

    final container = ProviderContainer(
      overrides: [
        updateStage52DataProvider.overrideWithValue(UpdateStage52Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final form = container.read(stage52FormProvider.notifier);

    await form.submit(
      data: _record(id: 'c', photoPath: 'http://cdn/existing.jpg'),
      isNew: false,
    );

    final state = container.read(stage52FormProvider);
    expect(state.status, Stage52FormStatus.error);
    expect(state.errorMessage, contains('update failed'));
  });
}
