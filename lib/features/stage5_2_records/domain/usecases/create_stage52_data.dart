import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';

class CreateStage52Data {
  final Stage52Repository repository;

  CreateStage52Data(this.repository);

  Future<void> call(Stage52RecordData data) {
    return repository.create(data);
  }
}
