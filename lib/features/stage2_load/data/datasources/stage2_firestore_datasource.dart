import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage2_load/data/models/stage2_load_model.dart';

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

  Future<List<Stage2LoadModel>> getAll() async {
    final querySnapshot = await _firestore.collection('stage2').get();
    return querySnapshot.docs
        .map((doc) => Stage2LoadModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage2').doc(id).delete();
  }
}
