import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';

class WatchStage51Data {
  final Stage51Repository repository;

  WatchStage51Data(this.repository);

  Stream<List<PaymentData>> call() {
    return repository.watch();
  }
}
