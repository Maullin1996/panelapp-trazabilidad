import '../entities/stage1_form_data.dart';
import '../repositories/stage1_repository.dart';

class WatchStage1Projects {
  final Stage1Repository repository;

  WatchStage1Projects(this.repository);

  Stream<List<Stage1FormData>> call({int limit = 10}) {
    return repository.watch(limit: limit);
  }
}
