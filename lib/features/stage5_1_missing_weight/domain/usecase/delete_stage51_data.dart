import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';

class DeleteStage51Data {
  final Stage51Repository repository;

  DeleteStage51Data(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
