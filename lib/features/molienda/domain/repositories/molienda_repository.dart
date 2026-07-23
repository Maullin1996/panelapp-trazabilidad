import '../entities/molienda.dart';
import '../entities/entrega.dart';

abstract class MoliendaRepository {
  Future<void> create(Molienda molienda);
  Future<void> update(Molienda molienda);
  Future<void> delete(String id);
  Stream<List<Molienda>> watchAll();
  Future<List<Molienda>> getAll();
  Future<void> createEntrega(Entrega entrega);
  Stream<List<Entrega>> watchEntregas(String moliendaId);
  Future<Entrega?> getEntregaByQrToken(String qrToken);
}
