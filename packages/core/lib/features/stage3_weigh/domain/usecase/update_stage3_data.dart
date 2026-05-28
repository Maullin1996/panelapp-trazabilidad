import '../entities/stage3_form_data.dart';
import '../repositories/stage3_repository.dart';

class UpdateStage3Data {
  final Stage3Repository repository;

  UpdateStage3Data(this.repository);

  Future<void> call(Stage3FormData data) {
    return repository.update(data);
  }
}
