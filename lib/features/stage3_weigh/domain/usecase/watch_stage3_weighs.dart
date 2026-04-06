import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';

class WatchStage3Weighs {
  final Stage3Repository repository;

  WatchStage3Weighs(this.repository);

  Stream<List<Stage3FormData>> call() {
    return repository.watch();
  }
}
