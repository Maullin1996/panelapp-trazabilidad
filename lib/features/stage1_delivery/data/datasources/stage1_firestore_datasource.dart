import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage1_delivery/data/models/stage1_form_model.dart';

class Stage1FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage1FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage1FormModel model) async {
    await _firestore.collection('stage1').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage1FormModel model) async {
    await _firestore.collection('stage1').doc(model.id).update(model.toJson());
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage1').doc(id).delete();
  }

  Stream<List<Stage1FormModel>> watchAll({int limit = 10}) {
    return _firestore
        .collection('stage1')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Stage1FormModel.fromJson(doc.data()))
              .toList();
        });
  }
}
