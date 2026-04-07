import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';

class WatchStage52Data {
  final Stage52Repository repository;

  WatchStage52Data(this.repository);

  Stream<List<Stage52RecordData>> call() {
    return repository.watch();
  }
}
