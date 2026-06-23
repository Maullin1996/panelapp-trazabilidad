import '../../domain/entities/molienda.dart';
import '../../domain/entities/entrega.dart';
import '../../domain/repositories/molienda_repository.dart';
import '../datasources/molienda_firestore_datasource.dart';
import '../models/molienda_model.dart';
import '../models/entrega_model.dart';

class MoliendaRepositoryImpl implements MoliendaRepository {
  final MoliendaFirestoreDatasource datasource;

  MoliendaRepositoryImpl(this.datasource);

  @override
  Future<void> create(Molienda molienda) =>
      datasource.create(MoliendaModel.fromEntity(molienda));

  @override
  Future<void> update(Molienda molienda) =>
      datasource.update(MoliendaModel.fromEntity(molienda));

  @override
  Future<void> delete(String id) => datasource.delete(id);

  @override
  Stream<List<Molienda>> watchAll() =>
      datasource.watchAll().map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<List<Molienda>> getAll() async {
    final models = await datasource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createEntrega(Entrega entrega) =>
      datasource.createEntrega(EntregaModel.fromEntity(entrega));

  @override
  Stream<List<Entrega>> watchEntregas(String moliendaId) =>
      datasource.watchEntregas(moliendaId)
          .map((models) => models.map((m) => m.toEntity()).toList());

  @override
  Future<Entrega?> getEntregaByQrToken(String qrToken) =>
      datasource.getEntregaByQrToken(qrToken);
}
