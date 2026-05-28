import '../entities/payment_data.dart';
import '../repositories/stage51_repository.dart';

class CreateStage51Data {
  final Stage51Repository repository;

  CreateStage51Data(this.repository);

  Future<void> call(PaymentData data) {
    return repository.create(data);
  }
}
