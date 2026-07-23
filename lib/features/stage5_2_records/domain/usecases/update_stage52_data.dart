import '../entities/stage52_record_data.dart';
import '../repositories/stage52_repository.dart';

class UpdateStage52Data {
  final Stage52Repository repository;

  UpdateStage52Data(this.repository);

  Future<void> call(Stage52RecordData data) {
    return repository.update(data);
  }
}
