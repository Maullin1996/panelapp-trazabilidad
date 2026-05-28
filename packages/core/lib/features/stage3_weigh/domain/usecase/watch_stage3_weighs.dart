import '../entities/stage3_form_data.dart';
import '../repositories/stage3_repository.dart';

class WatchStage3Weighs {
  final Stage3Repository repository;

  WatchStage3Weighs(this.repository);

  Stream<List<Stage3FormData>> call() {
    return repository.watch();
  }
}
