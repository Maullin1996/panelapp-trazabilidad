import '../entities/payment_data.dart';
import '../repositories/stage51_repository.dart';

class WatchStage51Data {
  final Stage51Repository repository;

  WatchStage51Data(this.repository);

  Stream<List<PaymentData>> call() {
    return repository.watch();
  }
}
