import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/data/models/stage51_payment_data_model.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';

void main() {
  final tDate = DateTime(2024, 1, 15);

  final tModel = PaymentDataModel(
    id: 'test-id',
    projectId: 'project-123',
    date: tDate.toIso8601String(),
    amount: 150.75,
  );

  final tJson = {
    'id': 'test-id',
    'projectId': 'project-123',
    'date': tDate.toIso8601String(),
    'amount': 150.75,
  };

  group('PaymentDataModel', () {
    test('fromJson construye el modelo correctamente', () {
      final result = PaymentDataModel.fromJson(tJson);

      expect(result.id, 'test-id');
      expect(result.projectId, 'project-123');
      expect(result.amount, 150.75);
      expect(result.date, tDate.toIso8601String());
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], 'test-id');
      expect(result['projectId'], 'project-123');
      expect(result['amount'], 150.75);
      expect(result['date'], tDate.toIso8601String());
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final fromJson = PaymentDataModel.fromJson(tJson);
      final backToJson = fromJson.toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['projectId'], tJson['projectId']);
      expect(backToJson['amount'], tJson['amount']);
    });

    test('toEntity convierte al entity de dominio correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<PaymentData>());
      expect(entity.id, tModel.id);
      expect(entity.amount, 150.75);
      expect(entity.date, tDate);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = PaymentData(
        id: 'test-id',
        projectId: 'project-123',
        date: tDate,
        amount: 150.75,
      );

      final model = PaymentDataModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.amount, entity.amount);
      expect(model.date, entity.date.toIso8601String());
    });
  });
}
