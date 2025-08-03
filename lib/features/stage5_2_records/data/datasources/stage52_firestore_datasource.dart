import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage5_2_records/data/models/stage52_record_model.dart';

class Stage52FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage52FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage52RecordModel model) async {
    await _firestore.collection('stage52').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage52RecordModel model) async {
    await _firestore.collection('stage52').doc(model.id).update(model.toJson());
  }

  Future<List<Stage52RecordModel>> getAll() async {
    final querySnapShot = await _firestore.collection('stage52').get();
    return querySnapShot.docs
        .map((doc) => Stage52RecordModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage52').doc(id).delete();
  }
}
