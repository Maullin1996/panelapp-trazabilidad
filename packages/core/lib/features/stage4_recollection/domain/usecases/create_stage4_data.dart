import '../entities/stage4_form_data.dart';
import '../repositories/stage4_repository.dart';

class CreateStage4Data {
  final Stage4Repository repository;

  CreateStage4Data(this.repository);

  Future<void> call(Stage4FormData data) {
    return repository.create(data);
  }
}
