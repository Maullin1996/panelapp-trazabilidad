import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';

class UpdateStage3Data {
  final Stage3Repository repository;

  UpdateStage3Data(this.repository);

  Future<void> call(Stage3FormData data) {
    return repository.update(data);
  }
}
