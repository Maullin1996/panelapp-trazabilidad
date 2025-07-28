import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';

class DeleteStage3Data {
  final Stage3Repository repository;

  DeleteStage3Data(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}
