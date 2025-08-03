import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';

class DeleteStage52Data {
  final Stage52Repository repository;

  DeleteStage52Data(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
