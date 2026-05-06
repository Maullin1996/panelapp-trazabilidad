import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage1_delivery/data/models/stage1_form_model.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

void main() {
  final tDate = DateTime(2024, 1, 15);

  final tModel = Stage1FormModel(
    id: 'test-id',
    name: 'Juan Pérez',
    gaveras: [
      {'quantity': 5, 'referenceWeight': 12.5},
    ],
    basketsQuantity: 3,
    preservativesWeight: 1.5,
    preservativesJars: 2,
    limeWeight: 0.8,
    limeJars: 1,
    phone: '3001234567',
    date: tDate,
    photoPath: 'https://example.com/photo.jpg',
  );
  final tJson = {
    'id': 'test-id',
    'name': 'Juan Pérez',
    'gaveras': [
      {'quantity': 5, 'referenceWeight': 12.5},
    ],
    'basketsQuantity': 3,
    'preservativesWeight': 1.5,
    'preservativesJars': 2,
    'limeWeight': 0.8,
    'limeJars': 1,
    'phone': '3001234567',
    'date': tDate.toIso8601String(),
    'photoPath': 'https://example.com/photo.jpg',
  };
  group('Stage1FormModel', () {
    test('fromJson construye el modelo correctamente', () {
      final result = Stage1FormModel.fromJson(tJson);

      expect(result.id, 'test-id');
      expect(result.name, 'Juan Pérez');
      expect(result.basketsQuantity, 3);
      expect(result.gaveras.first['quantity'], 5);
      expect(result.date, tDate);
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], 'test-id');
      expect(result['name'], 'Juan Pérez');
      expect(result['date'], tDate.toIso8601String());
      expect(result['gaveras'], isA<List>());
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final fromJson = Stage1FormModel.fromJson(tJson);
      final backToJson = fromJson.toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['name'], tJson['name']);
      expect(backToJson['date'], tJson['date']);
    });

    test('toEntity convierte al entity de dominio correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<Stage1FormData>());
      expect(entity.id, tModel.id);
      expect(entity.gaveras.first.quantity, 5);
      expect(entity.gaveras.first.referenceWeight, 12.5);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = Stage1FormData(
        id: 'test-id',
        name: 'Juan Pérez',
        gaveras: [GaveraData(quantity: 5, referenceWeight: 12.5)],
        basketsQuantity: 3,
        preservativesWeight: 1.5,
        preservativesJars: 2,
        limeWeight: 0.8,
        limeJars: 1,
        phone: '3001234567',
        date: tDate,
      );

      final model = Stage1FormModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.gaveras.first['referenceWeight'], 12.5);
    });

    test('fromJson usa defaults cuando faltan campos opcionales', () {
      final sparseJson = {'id': 'only-id'};
      final result = Stage1FormModel.fromJson(sparseJson);

      expect(result.name, '');
      expect(result.basketsQuantity, 0);
      expect(result.gaveras, isEmpty);
      expect(result.photoPath, isNull);
    });
  });
}
