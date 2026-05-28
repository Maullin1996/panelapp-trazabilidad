import '../entities/stage1_form_data.dart';
import '../repositories/stage1_repository.dart';

class CreateStage1Data {
  final Stage1Repository repository;

  CreateStage1Data(this.repository);

  Future<void> call(Stage1FormData data) {
    return repository.create(data);
  }
}
