import '../entities/stage1_form_data.dart';
import '../repositories/stage1_repository.dart';

class GetStage1DataById {
  final Stage1Repository repository;

  GetStage1DataById(this.repository);

  Future<Stage1FormData?> call(String id) {
    return repository.getById(id);
  }
}
