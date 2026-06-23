import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/molienda_model.dart';
import '../models/entrega_model.dart';
import '../../domain/entities/entrega.dart';

class MoliendaFirestoreDatasource {
  final FirebaseFirestore _firestore;

  MoliendaFirestoreDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('moliendas');

  CollectionReference<Map<String, dynamic>> _entregasCol(String moliendaId) =>
      _col.doc(moliendaId).collection('entregas');

  // ── Moliendas CRUD ──────────────────────────────────────────────────────────

  Future<void> create(MoliendaModel model) async {
    await _col.doc(model.id).set(model.toJson());
  }

  Future<void> update(MoliendaModel model) async {
    await _col.doc(model.id).update(model.toJson());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  Stream<List<MoliendaModel>> watchAll() {
    return _col
        .orderBy('nombre')
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => MoliendaModel.fromJson(doc.data()))
            .toList());
  }

  Future<List<MoliendaModel>> getAll() async {
    final snap = await _col.orderBy('nombre').get();
    return snap.docs.map((doc) => MoliendaModel.fromJson(doc.data())).toList();
  }

  // ── Entregas ────────────────────────────────────────────────────────────────

  Future<void> createEntrega(EntregaModel model) async {
    await _entregasCol(model.moliendaId).doc(model.id).set(model.toJson());
  }

  Stream<List<EntregaModel>> watchEntregas(String moliendaId) {
    return _entregasCol(moliendaId)
        .orderBy('fechaEntrega', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => EntregaModel.fromJson(doc.data()))
            .toList());
  }

  Future<Entrega?> getEntregaByQrToken(String qrToken) async {
    // Busca en todas las moliendas (collectionGroup)
    final snap = await _firestore
        .collectionGroup('entregas')
        .where('qrToken', isEqualTo: qrToken)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return EntregaModel.fromJson(snap.docs.first.data()).toEntity();
  }
}
