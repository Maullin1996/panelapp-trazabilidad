import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_panela/features/stage3_weigh/data/datasources/stage3_firestore_datasource.dart';
import 'package:registro_panela/features/stage3_weigh/data/models/stage3_model.dart';
import 'package:registro_panela/features/stage3_weigh/data/repositories_impl/stage3_repository_impl.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';

class MockStage3FirestoreDatasource extends Mock
    implements Stage3FirestoreDatasource {}

class FakeStage3Model extends Fake implements Stage3Model {}

void main() {
  late MockStage3FirestoreDatasource mockDatasource;
  late Stage3RepositoryImpl repository;

  final tData = Stage3FormData(
    id: 'test-id',
    projectId: 'project-123',
    stage2LoadId: 'load-456',
    date: DateTime(2024, 1, 1),
    baskets: [
      BasketWeighData(
        id: 'basket-1',
        sequence: 1,
        referenceWeight: 12.5,
        realWeight: 11.8,
        quality: BasketQuality.buena,
        photoPath: 'https://example.com/photo.jpg',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(FakeStage3Model());
  });

  setUp(() {
    mockDatasource = MockStage3FirestoreDatasource();
    repository = Stage3RepositoryImpl(mockDatasource);
  });

  group('Stage3RepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tData);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as Stage3Model;

      expect(captured.id, tData.id);
      expect(captured.stage2LoadId, tData.stage2LoadId);
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
        Stage3Model(
          id: 'test-id',
          projectId: 'project-123',
          stage2LoadId: 'load-456',
          date: DateTime(2024),
          baskets: [
            {
              'id': 'basket-1',
              'sequence': 1,
              'referenceWeight': 12.5,
              'realWeight': 11.8,
              'quality': 'regular',
              'photoPath': '',
            },
          ],
        ),
      ];

      when(
        () => mockDatasource.watchAll(),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watch().first;

      expect(result, isA<List<Stage3FormData>>());
      expect(result.first.id, 'test-id');
      expect(result.first.baskets.first.quality, BasketQuality.regular);
    });
  });
}
