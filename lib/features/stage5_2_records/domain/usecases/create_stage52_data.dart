import '../entities/stage52_record_data.dart';
import '../repositories/stage52_repository.dart';

class CreateStage52Data {
  final Stage52Repository repository;

  CreateStage52Data(this.repository);

  Future<void> call(Stage52RecordData data) {
    return repository.create(data);
  }
}
