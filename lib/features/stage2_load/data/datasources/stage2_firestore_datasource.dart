import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stage2_load_model.dart';

class Stage2FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage2FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage2LoadModel model) async {
    await _firestore.collection('stage2').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage2LoadModel model) async {
    await _firestore.collection('stage2').doc(model.id).update(model.toJson());
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage2').doc(id).delete();
  }

  Stream<List<Stage2LoadModel>> watchAll() {
    return _firestore
        .collection('stage2')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Stage2LoadModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
