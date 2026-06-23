import 'package:flutter_test/flutter_test.dart';
import 'package:core/features/stage3_weigh/data/models/stage3_model.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:core/features/stage3_weigh/domain/entities/stage3_form_data.dart';

void main() {
  final tDate = DateTime(2024, 1, 15);

  final tBasketMap = {
    'id': 'basket-1',
    'sequence': 1,
    'referenceWeight': 12.5,
    'realWeight': 11.8,
    'quality': 'buena',
    'photoPath': 'https://example.com/photo.jpg',
  };

  final tModel = Stage3Model(
    id: 'test-id',
    projectId: 'project-123',
    stage2LoadId: 'load-456',
    date: tDate,
    baskets: [tBasketMap],
  );

  final tJson = {
    'id': 'test-id',
    'projectId': 'project-123',
    'stage2LoadId': 'load-456',
    'date': tDate.toIso8601String(),
    'baskets': [tBasketMap],
  };

  group('Stage3Model', () {
    test('fromJson construye el modelo correctamente', () {
      final result = Stage3Model.fromJson(tJson);

      expect(result.id, 'test-id');
      expect(result.projectId, 'project-123');
      expect(result.stage2LoadId, 'load-456');
      expect(result.date, tDate);
      expect(result.baskets.first['quality'], 'buena');
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], 'test-id');
      expect(result['projectId'], 'project-123');
      expect(result['stage2LoadId'], 'load-456');
      expect(result['date'], tDate.toIso8601String());
      expect(result['baskets'], isA<List>());
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final fromJson = Stage3Model.fromJson(tJson);
      final backToJson = fromJson.toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['stage2LoadId'], tJson['stage2LoadId']);
      expect(backToJson['date'], tJson['date']);
    });

    test('toEntity convierte al entity de dominio correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<Stage3FormData>());
      expect(entity.id, tModel.id);
      expect(entity.baskets.first.quality, BasketQuality.buena);
      expect(entity.baskets.first.realWeight, 11.8);
      expect(entity.baskets.first.sequence, 1);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = Stage3FormData(
        id: 'test-id',
        projectId: 'project-123',
        stage2LoadId: 'load-456',
        date: tDate,
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

      final model = Stage3Model.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.baskets.first['quality'], 'buena');
      expect(model.baskets.first['realWeight'], 11.8);
    });

    test('fromJson usa defaults cuando faltan campos opcionales', () {
      final sparseJson = {'id': 'only-id'};
      final result = Stage3Model.fromJson(sparseJson);

      expect(result.id, 'only-id');
      expect(result.projectId, '');
      expect(result.stage2LoadId, '');
      expect(result.baskets, isEmpty);
    });
  });
}
