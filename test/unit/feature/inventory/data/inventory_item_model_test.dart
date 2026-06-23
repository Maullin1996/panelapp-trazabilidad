import 'package:flutter_test/flutter_test.dart';
import 'package:core/features/inventory/data/models/inventory_item_model.dart';
import 'package:core/features/inventory/domain/entities/inventory_item.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';

void main() {
  group('InventoryItemModel — gavera', () {
    const tId = 'gavera-1';

    final tModel = InventoryItemModel(
      id: tId,
      type: InventoryItemType.gavera,
      totalUnits: 10,
      availableUnits: 8,
      referenceWeight: 500.0,
      gaveraType: 'Kilo',
    );

    final tJson = {
      'id': tId,
      'type': 'gavera',
      'totalUnits': 10,
      'availableUnits': 8,
      'referenceWeight': 500.0,
      'gaveraType': 'Kilo',
    };

    test('fromJson construye el modelo correctamente', () {
      final result = InventoryItemModel.fromJson(tJson);

      expect(result.id, tId);
      expect(result.type, InventoryItemType.gavera);
      expect(result.totalUnits, 10);
      expect(result.availableUnits, 8);
      expect(result.referenceWeight, 500.0);
      expect(result.gaveraType, 'Kilo');
      expect(result.size, isNull);
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], tId);
      expect(result['type'], 'gavera');
      expect(result['totalUnits'], 10);
      expect(result['availableUnits'], 8);
      expect(result['referenceWeight'], 500.0);
      expect(result['gaveraType'], 'Kilo');
      expect(result.containsKey('size'), isFalse);
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final backToJson = InventoryItemModel.fromJson(tJson).toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['type'], tJson['type']);
      expect(backToJson['referenceWeight'], tJson['referenceWeight']);
      expect(backToJson['gaveraType'], tJson['gaveraType']);
    });

    test('toEntity convierte al entity correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<InventoryItem>());
      expect(entity.id, tId);
      expect(entity.type, InventoryItemType.gavera);
      expect(entity.totalUnits, 10);
      expect(entity.availableUnits, 8);
      expect(entity.referenceWeight, 500.0);
      expect(entity.gaveraType, 'Kilo');
      expect(entity.size, isNull);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = InventoryItem(
        id: tId,
        type: InventoryItemType.gavera,
        totalUnits: 10,
        availableUnits: 8,
        referenceWeight: 500.0,
        gaveraType: 'Kilo',
      );

      final model = InventoryItemModel.fromEntity(entity);

      expect(model.id, tId);
      expect(model.type, InventoryItemType.gavera);
      expect(model.referenceWeight, 500.0);
      expect(model.gaveraType, 'Kilo');
      expect(model.size, isNull);
    });
  });

  group('InventoryItemModel — canastilla', () {
    const tId = 'canastilla-1';

    final tModel = InventoryItemModel(
      id: tId,
      type: InventoryItemType.canastilla,
      totalUnits: 20,
      availableUnits: 15,
      size: BasketSize.grande,
    );

    final tJson = {
      'id': tId,
      'type': 'canastilla',
      'totalUnits': 20,
      'availableUnits': 15,
      'size': 'grande',
    };

    test('fromJson construye el modelo correctamente', () {
      final result = InventoryItemModel.fromJson(tJson);

      expect(result.id, tId);
      expect(result.type, InventoryItemType.canastilla);
      expect(result.size, BasketSize.grande);
      expect(result.referenceWeight, isNull);
      expect(result.gaveraType, isNull);
    });

    test('toJson omite campos nulos de gavera', () {
      final result = tModel.toJson();

      expect(result['type'], 'canastilla');
      expect(result['size'], 'grande');
      expect(result.containsKey('referenceWeight'), isFalse);
      expect(result.containsKey('gaveraType'), isFalse);
    });

    test('toEntity convierte al entity correctamente', () {
      final entity = tModel.toEntity();

      expect(entity.type, InventoryItemType.canastilla);
      expect(entity.size, BasketSize.grande);
      expect(entity.referenceWeight, isNull);
    });
  });
}
