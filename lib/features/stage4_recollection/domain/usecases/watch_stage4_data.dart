import '../entities/stage4_form_data.dart';
import '../repositories/stage4_repository.dart';

class WatchStage4Data {
  final Stage4Repository repository;

  WatchStage4Data(this.repository);

  Stream<List<Stage4FormData>> call(String projectId) {
    return repository.watch(projectId);
  }
}
