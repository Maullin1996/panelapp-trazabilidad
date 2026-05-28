import '../entities/stage2_load_data.dart';
import '../repositories/stage2_repository.dart';

class UpdateStage2Data {
  final Stage2Repository repository;

  UpdateStage2Data(this.repository);

  Future<void> call(Stage2LoadData data) {
    return repository.update(data);
  }
}
