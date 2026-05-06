import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_panela/features/stage2_load/data/datasources/stage2_firestore_datasource.dart';
import 'package:registro_panela/features/stage2_load/data/models/stage2_load_model.dart';
import 'package:registro_panela/features/stage2_load/data/repositories_impl/stage2_repository_impl.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';

class MockStage2FirestoreDatasource extends Mock
    implements Stage2FirestoreDatasource {}

class FakeStage2LoadModel extends Fake implements Stage2LoadModel {}

void main() {
  late MockStage2FirestoreDatasource mockDatasource;
  late Stage2RepositoryImpl repository;

  final tData = Stage2LoadData(
    id: 'test-id',
    projectId: 'project-123',
    date: DateTime(2024, 1, 1),
    baskets: BasketLoadData(referenceWeight: 12.5, count: 5, realWeight: 11.8),
  );

  setUpAll(() {
    registerFallbackValue(FakeStage2LoadModel());
  });

  setUp(() {
    mockDatasource = MockStage2FirestoreDatasource();
    repository = Stage2RepositoryImpl(mockDatasource);
  });

  group('Stage2RepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tData);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as Stage2LoadModel;

      expect(captured.id, tData.id);
      expect(captured.projectId, tData.projectId);
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
        Stage2LoadModel(
          id: 'test-id',
          projectId: 'project-123',
          date: DateTime(2024),
          baskets: {'referenceWeight': 12.5, 'count': 5, 'realWeight': 11.8},
        ),
      ];

      when(
        () => mockDatasource.watchAll(),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watch().first;

      expect(result, isA<List<Stage2LoadData>>());
      expect(result.first.id, 'test-id');
      expect(result.first.baskets.count, 5);
    });
  });
}
