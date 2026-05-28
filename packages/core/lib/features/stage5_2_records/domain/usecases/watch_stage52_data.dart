import '../entities/stage52_record_data.dart';
import '../repositories/stage52_repository.dart';

class WatchStage52Data {
  final Stage52Repository repository;

  WatchStage52Data(this.repository);

  Stream<List<Stage52RecordData>> call() {
    return repository.watch();
  }
}
