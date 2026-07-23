import '../repositories/stage1_repository.dart';

class DeleteStage1Data {
  final Stage1Repository repository;

  DeleteStage1Data(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
