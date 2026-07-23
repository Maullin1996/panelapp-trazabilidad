import '../entities/payment_data.dart';

abstract class Stage51Repository {
  Future<void> create(PaymentData data);
  Future<void> delete(String id);
  Stream<List<PaymentData>> watch();
}
