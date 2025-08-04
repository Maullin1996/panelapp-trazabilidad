import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';

abstract class Stage51Repository {
  Future<void> create(PaymentData data);
  Future<List<PaymentData>> getAll();
  Future<void> delete(String id);
}
