import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/inventory_item_model.dart';

class InventoryFirestoreDatasource {
  final FirebaseFirestore _firestore;

  InventoryFirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('inventory');

  Future<void> create(InventoryItemModel model) async {
    await _col.doc(model.id).set(model.toJson());
  }

  Future<void> update(InventoryItemModel model) async {
    await _col.doc(model.id).update(model.toJson());
  }

  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  Stream<List<InventoryItemModel>> watchAll() {
    return _col.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => InventoryItemModel.fromJson(doc.data()))
          .toList(),
    );
  }

  Future<List<InventoryItemModel>> getAll() async {
    final snapshot = await _col.get();
    return snapshot.docs
        .map((doc) => InventoryItemModel.fromJson(doc.data()))
        .toList();
  }

  /// Descuenta availableUnits al enviar en stage1
  Future<void> decrementAvailable(String id, int quantity) async {
    print('Decrementando id: $id cantidad: $quantity');
    await _firestore.runTransaction((tx) async {
      final ref = _col.doc(id);
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Item de inventario no encontrado');
      final current = (snap.data()!['availableUnits'] as num).toInt();
      final next = (current - quantity).clamp(0, current);
      print('current: $current next: $next');
      tx.update(ref, {'availableUnits': next});
    });
    print('Decremento completado');
  }

  /// Suma availableUnits al devolver en stage4
  Future<void> incrementAvailable(String id, int quantity) async {
    await _firestore.runTransaction((tx) async {
      final ref = _col.doc(id);
      final snap = await tx.get(ref);
      if (!snap.exists) throw Exception('Item de inventario no encontrado');
      final current = (snap.data()!['availableUnits'] as num).toInt();
      final total = (snap.data()!['totalUnits'] as num).toInt();
      final next = (current + quantity).clamp(0, total);
      tx.update(ref, {'availableUnits': next});
    });
  }
}
