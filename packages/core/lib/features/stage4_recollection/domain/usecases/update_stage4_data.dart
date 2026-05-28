import '../entities/stage4_form_data.dart';
import '../repositories/stage4_repository.dart';

class UpdateStage4Data {
  final Stage4Repository repository;

  UpdateStage4Data(this.repository);

  Future<void> call(Stage4FormData data) {
    return repository.update(data);
  }
}
