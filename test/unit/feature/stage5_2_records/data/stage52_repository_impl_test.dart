import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage5_2_records/data/datasources/stage52_firestore_datasource.dart';
import 'package:core/features/stage5_2_records/data/models/stage52_record_model.dart';
import 'package:core/features/stage5_2_records/data/repositories_impl/stage52_repository_impl.dart';
import 'package:core/features/stage5_2_records/domain/entities/stage52_record_data.dart';

class MockStage52FirestoreDatasource extends Mock
    implements Stage52FirestoreDatasource {}

class FakeStage52RecordModel extends Fake implements Stage52RecordModel {}

void main() {
  late MockStage52FirestoreDatasource mockDatasource;
  late Stage52RepositoryImpl repository;

  final tData = Stage52RecordData(
    id: 'test-id',
    projectId: 'project-123',
    gaveraWeight: 12.5,
    panelaWeight: 50.0,
    unitCount: 10,
    quality: BasketQuality.buena,
    photoPath: 'https://example.com/photo.jpg',
    date: DateTime(2024, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeStage52RecordModel());
  });

  setUp(() {
    mockDatasource = MockStage52FirestoreDatasource();
    repository = Stage52RepositoryImpl(mockDatasource);
  });

  group('Stage52RepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tData);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as Stage52RecordModel;

      expect(captured.id, tData.id);
      expect(captured.quality, BasketQuality.buena);
    });

    test('update llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.update(any())).thenAnswer((_) async {});

      await repository.update(tData);

      verify(() => mockDatasource.update(any())).called(1);
    });

    test('delete llama al datasource con el id correcto', () async {
      when(() => mockDatasource.delete(any())).thenAnswer((_) async {});

      await repository.delete('test-id');

      verify(() => mockDatasource.delete('test-id')).called(1);
    });

    test('watch convierte los modelos a entities', () async {
      final models = [
        Stage52RecordModel(
          id: 'test-id',
          projectId: 'project-123',
          gaveraWeight: 12.5,
          panelaWeight: 50.0,
          unitCount: 10,
          quality: BasketQuality.buena,
          photoPath: '',
          date: DateTime(2024),
        ),
      ];

      when(
        () => mockDatasource.watchAll(),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watch().first;

      expect(result, isA<List<Stage52RecordData>>());
      expect(result.first.id, 'test-id');
      expect(result.first.quality, BasketQuality.buena);
    });
  });
}
