import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/domain/repositories/stage1_repository.dart';

class WatchStage1Projects {
  final Stage1Repository repository;

  WatchStage1Projects(this.repository);

  Stream<List<Stage1FormData>> call() {
    return repository.watch();
  }
}
