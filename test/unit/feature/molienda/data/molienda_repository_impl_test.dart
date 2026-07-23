import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_panela/features/molienda/data/datasources/molienda_firestore_datasource.dart';
import 'package:registro_panela/features/molienda/data/models/molienda_model.dart';
import 'package:registro_panela/features/molienda/data/models/entrega_model.dart';
import 'package:registro_panela/features/molienda/data/repositories/molienda_repository_impl.dart';
import 'package:registro_panela/features/molienda/domain/entities/molienda.dart';
import 'package:registro_panela/features/molienda/domain/entities/entrega.dart';

class MockMoliendaFirestoreDatasource extends Mock
    implements MoliendaFirestoreDatasource {}

class FakeMoliendaModel extends Fake implements MoliendaModel {}

class FakeEntregaModel extends Fake implements EntregaModel {}

void main() {
  late MockMoliendaFirestoreDatasource mockDatasource;
  late MoliendaRepositoryImpl repository;

  final tDate = DateTime(2026, 1, 15, 10, 30);

  final tMolienda = Molienda(
    id: 'molienda-1',
    nombre: 'Molienda El Paraíso',
    telefono: '3000000000',
    creadoEn: tDate,
  );

  final tEntrega = Entrega(
    id: 'entrega-1',
    moliendaId: 'molienda-1',
    produccionId: 'produccion-1',
    fechaEntrega: tDate,
    qrToken: 'qr-token-uuid',
  );

  setUpAll(() {
    registerFallbackValue(FakeMoliendaModel());
    registerFallbackValue(FakeEntregaModel());
  });

  setUp(() {
    mockDatasource = MockMoliendaFirestoreDatasource();
    repository = MoliendaRepositoryImpl(mockDatasource);
  });

  group('MoliendaRepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tMolienda);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as MoliendaModel;
      expect(captured.id, tMolienda.id);
      expect(captured.nombre, tMolienda.nombre);
      expect(captured.telefono, tMolienda.telefono);
    });

    test('update llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.update(any())).thenAnswer((_) async {});

      await repository.update(tMolienda);

      final captured =
          verify(() => mockDatasource.update(captureAny())).captured.first
              as MoliendaModel;
      expect(captured.id, tMolienda.id);
      expect(captured.nombre, tMolienda.nombre);
    });

    test('delete llama al datasource con el id correcto', () async {
      when(() => mockDatasource.delete(any())).thenAnswer((_) async {});

      await repository.delete('molienda-1');

      verify(() => mockDatasource.delete('molienda-1')).called(1);
    });

    test('watchAll convierte los modelos a entities', () async {
      final models = [
        MoliendaModel(
          id: 'molienda-1',
          nombre: 'Molienda El Paraíso',
          telefono: '3000000000',
          creadoEn: tDate,
        ),
        MoliendaModel(
          id: 'molienda-2',
          nombre: 'Molienda La Esperanza',
          telefono: '3000000001',
          creadoEn: tDate,
        ),
      ];

      when(
        () => mockDatasource.watchAll(),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watchAll().first;

      expect(result, isA<List<Molienda>>());
      expect(result.length, 2);
      expect(result.first.nombre, 'Molienda El Paraíso');
      expect(result.last.nombre, 'Molienda La Esperanza');
    });

    test('getAll convierte los modelos a entities', () async {
      final models = [
        MoliendaModel(
          id: 'molienda-1',
          nombre: 'Molienda El Paraíso',
          telefono: '3000000000',
          creadoEn: tDate,
        ),
      ];

      when(() => mockDatasource.getAll()).thenAnswer((_) async => models);

      final result = await repository.getAll();

      expect(result, isA<List<Molienda>>());
      expect(result.first.id, 'molienda-1');
      expect(result.first.nombre, 'Molienda El Paraíso');
    });

    test('createEntrega llama al datasource con el modelo correcto', () async {
      when(
        () => mockDatasource.createEntrega(any()),
      ).thenAnswer((_) async {});

      await repository.createEntrega(tEntrega);

      final captured =
          verify(
                () => mockDatasource.createEntrega(captureAny()),
              ).captured.first
              as EntregaModel;
      expect(captured.id, tEntrega.id);
      expect(captured.moliendaId, tEntrega.moliendaId);
      expect(captured.qrToken, tEntrega.qrToken);
    });

    test('watchEntregas convierte los modelos a entities', () async {
      final models = [
        EntregaModel(
          id: 'entrega-1',
          moliendaId: 'molienda-1',
          produccionId: 'produccion-1',
          fechaEntrega: tDate,
          qrToken: 'qr-token-uuid',
        ),
      ];

      when(
        () => mockDatasource.watchEntregas('molienda-1'),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watchEntregas('molienda-1').first;

      expect(result, isA<List<Entrega>>());
      expect(result.length, 1);
      expect(result.first.id, 'entrega-1');
      expect(result.first.qrToken, 'qr-token-uuid');
    });

    test(
      'getEntregaByQrToken delega al datasource y retorna la entrega',
      () async {
        when(
          () => mockDatasource.getEntregaByQrToken('qr-token-uuid'),
        ).thenAnswer((_) async => tEntrega);

        final result = await repository.getEntregaByQrToken('qr-token-uuid');

        expect(result, tEntrega);
        verify(
          () => mockDatasource.getEntregaByQrToken('qr-token-uuid'),
        ).called(1);
      },
    );

    test('getEntregaByQrToken retorna null si no existe', () async {
      when(
        () => mockDatasource.getEntregaByQrToken('no-existe'),
      ).thenAnswer((_) async => null);

      final result = await repository.getEntregaByQrToken('no-existe');

      expect(result, isNull);
    });
  });
}
