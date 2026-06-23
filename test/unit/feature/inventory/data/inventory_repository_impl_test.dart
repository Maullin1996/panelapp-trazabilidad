import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/inventory/data/datasources/inventory_firestore_datasource.dart';
import 'package:core/features/inventory/data/models/inventory_item_model.dart';
import 'package:core/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:core/features/inventory/domain/entities/inventory_item.dart';

class MockInventoryFirestoreDatasource extends Mock
    implements InventoryFirestoreDatasource {}

class FakeInventoryItemModel extends Fake implements InventoryItemModel {}

void main() {
  late MockInventoryFirestoreDatasource mockDatasource;
  late InventoryRepositoryImpl repository;

  final tGavera = InventoryItem(
    id: 'gavera-1',
    type: InventoryItemType.gavera,
    totalUnits: 10,
    availableUnits: 8,
    referenceWeight: 500.0,
    gaveraType: 'Kilo',
  );

  final tCanastilla = InventoryItem(
    id: 'canastilla-1',
    type: InventoryItemType.canastilla,
    totalUnits: 20,
    availableUnits: 15,
  );

  setUpAll(() {
    registerFallbackValue(FakeInventoryItemModel());
  });

  setUp(() {
    mockDatasource = MockInventoryFirestoreDatasource();
    repository = InventoryRepositoryImpl(mockDatasource);
  });

  group('InventoryRepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tGavera);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as InventoryItemModel;
      expect(captured.id, tGavera.id);
      expect(captured.type, InventoryItemType.gavera);
      expect(captured.referenceWeight, 500.0);
    });

    test('update llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.update(any())).thenAnswer((_) async {});

      await repository.update(tCanastilla);

      final captured =
          verify(() => mockDatasource.update(captureAny())).captured.first
              as InventoryItemModel;
      expect(captured.id, tCanastilla.id);
      expect(captured.type, InventoryItemType.canastilla);
    });

    test('delete llama al datasource con el id correcto', () async {
      when(() => mockDatasource.delete(any())).thenAnswer((_) async {});

      await repository.delete('gavera-1');

      verify(() => mockDatasource.delete('gavera-1')).called(1);
    });

    test('watchAll convierte los modelos a entities', () async {
      final models = [
        InventoryItemModel(
          id: 'gavera-1',
          type: InventoryItemType.gavera,
          totalUnits: 10,
          availableUnits: 8,
          referenceWeight: 500.0,
          gaveraType: 'Kilo',
        ),
        InventoryItemModel(
          id: 'canastilla-1',
          type: InventoryItemType.canastilla,
          totalUnits: 20,
          availableUnits: 15,
        ),
      ];

      when(() => mockDatasource.watchAll())
          .thenAnswer((_) => Stream.value(models));

      final result = await repository.watchAll().first;

      expect(result, isA<List<InventoryItem>>());
      expect(result.length, 2);
      expect(result.first.type, InventoryItemType.gavera);
      expect(result.last.type, InventoryItemType.canastilla);
    });

    test('getAll convierte los modelos a entities', () async {
      final models = [
        InventoryItemModel(
          id: 'gavera-1',
          type: InventoryItemType.gavera,
          totalUnits: 10,
          availableUnits: 8,
          referenceWeight: 500.0,
          gaveraType: 'Kilo',
        ),
      ];

      when(() => mockDatasource.getAll()).thenAnswer((_) async => models);

      final result = await repository.getAll();

      expect(result, isA<List<InventoryItem>>());
      expect(result.first.id, 'gavera-1');
      expect(result.first.gaveraType, 'Kilo');
    });

    test('decrementAvailable delega al datasource', () async {
      when(() => mockDatasource.decrementAvailable(any(), any()))
          .thenAnswer((_) async {});

      await repository.decrementAvailable('gavera-1', 3);

      verify(() => mockDatasource.decrementAvailable('gavera-1', 3)).called(1);
    });

    test('incrementAvailable delega al datasource', () async {
      when(() => mockDatasource.incrementAvailable(any(), any()))
          .thenAnswer((_) async {});

      await repository.incrementAvailable('gavera-1', 2);

      verify(() => mockDatasource.incrementAvailable('gavera-1', 2)).called(1);
    });
  });
}
