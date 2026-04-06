import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/domain/repositories/stage2_repository.dart';

class WatchStage2Load {
  final Stage2Repository repository;

  WatchStage2Load(this.repository);

  Stream<List<Stage2LoadData>> call() {
    return repository.watch();
  }
}
