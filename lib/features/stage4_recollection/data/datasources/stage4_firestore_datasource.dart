import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage4_recollection/data/models/stage4_form_model.dart';

class Stage4FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage4FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage4FormModel model) async {
    await _firestore.collection('stage4').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage4FormModel model) async {
    await _firestore.collection('stage4').doc(model.id).set(model.toJson());
  }
}
