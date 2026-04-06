import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage3_weigh/data/models/stage3_model.dart';

class Stage3FirestoreDatasource {
  final FirebaseFirestore _firestore;

  Stage3FirestoreDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(Stage3Model model) async {
    await _firestore.collection('stage3').doc(model.id).set(model.toJson());
  }

  Future<void> update(Stage3Model model) async {
    await _firestore
        .collection('stage3')
        .doc(model.id)
        .set(model.toJson(), SetOptions(merge: true));
  }

  Future<List<Stage3Model>> getAll() async {
    final querySnapshot = await _firestore
        .collection('stage3')
        .orderBy('date', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => Stage3Model.fromJson(doc.data()))
        .toList();
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage3').doc(id).delete();
  }

  Stream<List<Stage3Model>> watchAll() {
    return _firestore
        .collection('stage3')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Stage3Model.fromJson(doc.data()))
              .toList(),
        );
  }
}
