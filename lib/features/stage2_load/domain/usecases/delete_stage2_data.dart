import '../repositories/stage2_repository.dart';

class DeleteStage2Data {
  final Stage2Repository repository;

  DeleteStage2Data(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
