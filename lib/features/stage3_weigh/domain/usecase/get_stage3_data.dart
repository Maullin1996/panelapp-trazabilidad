import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';

class GetStage3Data {
  final Stage3Repository repository;

  GetStage3Data(this.repository);

  Future<List<Stage3FormData>> call() {
    return repository.getAll();
  }
}
