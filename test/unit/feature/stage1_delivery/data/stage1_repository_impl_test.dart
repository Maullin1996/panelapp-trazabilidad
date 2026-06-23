import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/stage1_delivery/data/datasources/stage1_firestore_datasource.dart';
import 'package:core/features/stage1_delivery/data/models/stage1_form_model.dart';
import 'package:core/features/stage1_delivery/data/repositories_impl/stage1_repository_impl.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';

class MockStage1FirestoreDatasource extends Mock
    implements Stage1FirestoreDatasource {}

class FakeStage1FormModel extends Fake implements Stage1FormModel {}

void main() {
  late MockStage1FirestoreDatasource mockDatasource;
  late Stage1RepositoryImpl repository;

  final tData = Stage1FormData(
    id: 'test-id',
    name: 'Juan',
    gaveras: [GaveraData(quantity: 2, referenceWeight: 10.0, gaveraType: 'Kilo')],
    baskets: [BasketData(size: BasketSize.grande, quantity: 1)],
    preservativesWeight: 0.5,
    preservativesJars: 1,
    limeWeight: 0.3,
    limeJars: 1,
    phone: '300',
    date: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockDatasource = MockStage1FirestoreDatasource();
    repository = Stage1RepositoryImpl(mockDatasource);
  });

  setUpAll(() {
    registerFallbackValue(FakeStage1FormModel());
  });

  group('Stage1RepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tData);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as Stage1FormModel;
      expect(captured.id, tData.id);
      expect(captured.name, tData.name);
    });

    test('delete llama al datasource con el id correcto', () async {
      when(() => mockDatasource.delete(any())).thenAnswer((_) async {});

      await repository.delete('test-id');

      verify(() => mockDatasource.delete('test-id')).called(1);
    });

    test('update llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.update(any())).thenAnswer((_) async {});

      await repository.update(tData);

      verify(() => mockDatasource.update(any())).called(1);
    });

    test('watch convierte los modelos a entities', () async {
      final models = [
        Stage1FormModel(
          id: 'test-id',
          name: 'Juan',
          gaveras: [],
          baskets: [],
          preservativesWeight: 0,
          preservativesJars: 0,
          limeWeight: 0,
          limeJars: 0,
          phone: '',
          date: DateTime(2024),
        ),
      ];

      when(
        () => mockDatasource.watchAll(limit: any(named: 'limit')),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watch().first;

      expect(result, isA<List<Stage1FormData>>());
      expect(result.first.id, 'test-id');
    });
  });
}
