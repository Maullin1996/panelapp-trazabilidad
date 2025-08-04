import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';

class CreateStage51Data {
  final Stage51Repository repository;

  CreateStage51Data(this.repository);

  Future<void> call(PaymentData data) {
    return repository.create(data);
  }
}
