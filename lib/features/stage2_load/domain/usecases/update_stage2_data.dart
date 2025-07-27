import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/domain/repositories/stage2_repository.dart';

class UpdateStage2Data {
  final Stage2Repository repository;

  UpdateStage2Data(this.repository);

  Future<void> call(Stage2LoadData data) {
    return repository.update(data);
  }
}
