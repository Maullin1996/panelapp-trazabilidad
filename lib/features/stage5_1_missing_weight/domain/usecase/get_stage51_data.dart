import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';

class GetStage51Data {
  final Stage51Repository repository;

  GetStage51Data(this.repository);

  Future<List<PaymentData>> call() {
    return repository.getAll();
  }
}
