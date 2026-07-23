import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage2_load/data/models/stage2_load_model.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/basket_quality.dart';

void main() {
  final tDate = DateTime(2024, 1, 15);

  final tModel = Stage2LoadModel(
    id: 'test-id',
    projectId: 'project-123',
    date: tDate,
    baskets: {'referenceWeight': 12.5, 'count': 5, 'quality': 'buena'},
  );

  final tJson = {
    'id': 'test-id',
    'projectId': 'project-123',
    'date': tDate.toIso8601String(),
    'baskets': {'referenceWeight': 12.5, 'count': 5, 'quality': 'buena'},
  };

  group('Stage2LoadModel', () {
    test('fromJson construye el modelo correctamente', () {
      final result = Stage2LoadModel.fromJson(tJson);

      expect(result.id, 'test-id');
      expect(result.projectId, 'project-123');
      expect(result.date, tDate);
      expect(result.baskets['count'], 5);
      expect(result.baskets['quality'], 'buena');
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], 'test-id');
      expect(result['projectId'], 'project-123');
      expect(result['date'], tDate.toIso8601String());
      expect(result['baskets'], isA<Map>());
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final fromJson = Stage2LoadModel.fromJson(tJson);
      final backToJson = fromJson.toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['projectId'], tJson['projectId']);
      expect(backToJson['date'], tJson['date']);
    });

    test('toEntity convierte al entity de dominio correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<Stage2LoadData>());
      expect(entity.id, tModel.id);
      expect(entity.baskets.referenceWeight, 12.5);
      expect(entity.baskets.count, 5);
      expect(entity.baskets.quality, BasketQuality.buena);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = Stage2LoadData(
        id: 'test-id',
        projectId: 'project-123',
        date: tDate,
        baskets: BasketLoadData(
          referenceWeight: 12.5,
          count: 5,
          quality: BasketQuality.buena,
        ),
      );

      final model = Stage2LoadModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.baskets['referenceWeight'], 12.5);
      expect(model.baskets['count'], 5);
      expect(model.baskets['quality'], 'buena');
    });
  });
}
