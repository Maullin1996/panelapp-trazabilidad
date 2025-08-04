import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/data/models/stage51_payment_data_model.dart';

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

  Future<List<PaymentDataModel>> getAll() async {
    final querySnapshot = await _firestore.collection('stage51').get();
    return querySnapshot.docs
        .map((doc) => PaymentDataModel.fromJson(doc.data()))
        .toList();
  }
}
