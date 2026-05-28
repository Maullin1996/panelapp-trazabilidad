import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stage51_payment_data_model.dart';

class Stage51PaymentDatasource {
  final FirebaseFirestore _firestore;

  Stage51PaymentDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> create(PaymentDataModel model) async {
    await _firestore.collection('stage51').doc(model.id).set(model.toJson());
  }

  Future<void> delete(String id) async {
    await _firestore.collection('stage51').doc(id).delete();
  }

  Stream<List<PaymentDataModel>> watchAll() {
    return _firestore
        .collection('stage51')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PaymentDataModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
