import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registro_panela/features/molienda/data/models/molienda_model.dart';
import 'package:registro_panela/features/molienda/data/models/entrega_model.dart';
import 'package:registro_panela/features/molienda/domain/entities/molienda.dart';
import 'package:registro_panela/features/molienda/domain/entities/entrega.dart';

void main() {
  group('MoliendaModel', () {
    const tId = 'molienda-1';
    final tDate = DateTime(2026, 1, 15, 10, 30);

    final tModel = MoliendaModel(
      id: tId,
      nombre: 'Molienda El Paraíso',
      telefono: '3000000000',
      creadoEn: tDate,
    );

    final tJson = {
      'id': tId,
      'nombre': 'Molienda El Paraíso',
      'telefono': '3000000000',
      'creadoEn': Timestamp.fromDate(tDate),
    };

    test('fromJson construye el modelo correctamente', () {
      final result = MoliendaModel.fromJson(tJson);

      expect(result.id, tId);
      expect(result.nombre, 'Molienda El Paraíso');
      expect(result.telefono, '3000000000');
      expect(result.creadoEn, tDate);
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], tId);
      expect(result['nombre'], 'Molienda El Paraíso');
      expect(result['telefono'], '3000000000');
      expect(result['creadoEn'], isA<Timestamp>());
      expect((result['creadoEn'] as Timestamp).toDate(), tDate);
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final backToJson = MoliendaModel.fromJson(tJson).toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['nombre'], tJson['nombre']);
      expect(backToJson['telefono'], tJson['telefono']);
      expect(
        (backToJson['creadoEn'] as Timestamp).toDate(),
        (tJson['creadoEn'] as Timestamp).toDate(),
      );
    });

    test('toEntity convierte al entity correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<Molienda>());
      expect(entity.id, tId);
      expect(entity.nombre, 'Molienda El Paraíso');
      expect(entity.telefono, '3000000000');
      expect(entity.creadoEn, tDate);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = Molienda(
        id: tId,
        nombre: 'Molienda El Paraíso',
        telefono: '3000000000',
        creadoEn: tDate,
      );

      final model = MoliendaModel.fromEntity(entity);

      expect(model.id, tId);
      expect(model.nombre, 'Molienda El Paraíso');
      expect(model.telefono, '3000000000');
      expect(model.creadoEn, tDate);
    });
  });

  group('EntregaModel', () {
    const tId = 'entrega-1';
    const tMoliendaId = 'molienda-1';
    const tProduccionId = 'produccion-1';
    const tQrToken = 'qr-token-uuid';
    final tDate = DateTime(2026, 2, 1, 8, 0);

    final tModel = EntregaModel(
      id: tId,
      moliendaId: tMoliendaId,
      produccionId: tProduccionId,
      fechaEntrega: tDate,
      qrToken: tQrToken,
    );

    final tJson = {
      'id': tId,
      'moliendaId': tMoliendaId,
      'produccionId': tProduccionId,
      'fechaEntrega': Timestamp.fromDate(tDate),
      'qrToken': tQrToken,
    };

    test('fromJson construye el modelo correctamente', () {
      final result = EntregaModel.fromJson(tJson);

      expect(result.id, tId);
      expect(result.moliendaId, tMoliendaId);
      expect(result.produccionId, tProduccionId);
      expect(result.fechaEntrega, tDate);
      expect(result.qrToken, tQrToken);
    });

    test('toJson serializa todos los campos', () {
      final result = tModel.toJson();

      expect(result['id'], tId);
      expect(result['moliendaId'], tMoliendaId);
      expect(result['produccionId'], tProduccionId);
      expect(result['fechaEntrega'], isA<Timestamp>());
      expect((result['fechaEntrega'] as Timestamp).toDate(), tDate);
      expect(result['qrToken'], tQrToken);
    });

    test('fromJson → toJson es reversible (round-trip)', () {
      final backToJson = EntregaModel.fromJson(tJson).toJson();

      expect(backToJson['id'], tJson['id']);
      expect(backToJson['moliendaId'], tJson['moliendaId']);
      expect(backToJson['produccionId'], tJson['produccionId']);
      expect(backToJson['qrToken'], tJson['qrToken']);
      expect(
        (backToJson['fechaEntrega'] as Timestamp).toDate(),
        (tJson['fechaEntrega'] as Timestamp).toDate(),
      );
    });

    test('toEntity convierte al entity correctamente', () {
      final entity = tModel.toEntity();

      expect(entity, isA<Entrega>());
      expect(entity.id, tId);
      expect(entity.moliendaId, tMoliendaId);
      expect(entity.produccionId, tProduccionId);
      expect(entity.fechaEntrega, tDate);
      expect(entity.qrToken, tQrToken);
    });

    test('fromEntity construye el modelo desde el entity', () {
      final entity = Entrega(
        id: tId,
        moliendaId: tMoliendaId,
        produccionId: tProduccionId,
        fechaEntrega: tDate,
        qrToken: tQrToken,
      );

      final model = EntregaModel.fromEntity(entity);

      expect(model.id, tId);
      expect(model.moliendaId, tMoliendaId);
      expect(model.produccionId, tProduccionId);
      expect(model.fechaEntrega, tDate);
      expect(model.qrToken, tQrToken);
    });
  });
}
