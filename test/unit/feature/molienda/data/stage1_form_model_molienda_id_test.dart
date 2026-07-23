import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage1_delivery/data/models/stage1_form_model.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

void main() {
  final tDate = DateTime(2024, 1, 15);

  final tModel = Stage1FormModel(
    id: 'test-id',
    name: 'Juan Pérez',
    moliendaId: 'molienda-1',
    gaveras: const [],
    baskets: const [],
    preservativesWeight: 1.5,
    preservativesJars: 2,
    limeWeight: 0.8,
    limeJars: 1,
    phone: '3001234567',
    date: tDate,
  );

  final tJson = {
    'id': 'test-id',
    'name': 'Juan Pérez',
    'moliendaId': 'molienda-1',
    'gaveras': [],
    'baskets': [],
    'preservativesWeight': 1.5,
    'preservativesJars': 2,
    'limeWeight': 0.8,
    'limeJars': 1,
    'phone': '3001234567',
    'date': tDate.toIso8601String(),
    'photoPath': null,
  };

  group('Stage1FormModel moliendaId', () {
    test('toJson incluye moliendaId', () {
      final result = tModel.toJson();

      expect(result['moliendaId'], 'molienda-1');
    });

    test('fromJson lee moliendaId', () {
      final result = Stage1FormModel.fromJson(tJson);

      expect(result.moliendaId, 'molienda-1');
    });

    test('fromJson → toJson es reversible con moliendaId', () {
      final backToJson = Stage1FormModel.fromJson(tJson).toJson();

      expect(backToJson['moliendaId'], tJson['moliendaId']);
    });

    test('fromJson usa moliendaId null cuando no está presente', () {
      final sparseJson = {'id': 'only-id'};
      final result = Stage1FormModel.fromJson(sparseJson);

      expect(result.moliendaId, isNull);
    });

    test('fromEntity mapea moliendaId desde el entity', () {
      final entity = Stage1FormData(
        id: 'test-id',
        name: 'Juan Pérez',
        moliendaId: 'molienda-1',
        gaveras: const [],
        baskets: const [],
        preservativesWeight: 1.5,
        preservativesJars: 2,
        limeWeight: 0.8,
        limeJars: 1,
        phone: '3001234567',
        date: tDate,
      );

      final model = Stage1FormModel.fromEntity(entity);

      expect(model.moliendaId, 'molienda-1');
    });

    test('fromEntity mapea moliendaId null cuando el entity no lo tiene', () {
      final entity = Stage1FormData(
        id: 'test-id-2',
        name: 'Otro',
        gaveras: const [],
        baskets: const [],
        preservativesWeight: 0,
        preservativesJars: 0,
        limeWeight: 0,
        limeJars: 0,
        phone: '3000000000',
        date: tDate,
      );

      final model = Stage1FormModel.fromEntity(entity);

      expect(model.moliendaId, isNull);
    });

    test('toEntity mapea moliendaId hacia el entity', () {
      final entity = tModel.toEntity();

      expect(entity.moliendaId, 'molienda-1');
    });

    test('toEntity preserva moliendaId null cuando el modelo no lo tiene', () {
      final modelSinMolienda = Stage1FormModel(
        id: 'test-id-3',
        name: 'Otro',
        gaveras: const [],
        baskets: const [],
        preservativesWeight: 0,
        preservativesJars: 0,
        limeWeight: 0,
        limeJars: 0,
        phone: '3000000000',
        date: tDate,
      );

      final entity = modelSinMolienda.toEntity();

      expect(entity.moliendaId, isNull);
    });
  });
}
