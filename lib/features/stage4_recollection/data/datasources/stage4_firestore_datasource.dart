import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stage4_form_model.dart';

class Stage4FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage4FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage4FormModel model) async {
    await _firestore.collection('stage4').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage4FormModel model) async {
    await _firestore.collection('stage4').doc(model.id).update(model.toJson());
  }

  Stream<List<Stage4FormModel>> watchAll(String projectId) {
    return _firestore
        .collection('stage4')
        .where('projectId', isEqualTo: projectId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Stage4FormModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
