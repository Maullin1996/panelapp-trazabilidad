import '../entities/stage2_load_data.dart';
import '../repositories/stage2_repository.dart';

class WatchStage2Load {
  final Stage2Repository repository;

  WatchStage2Load(this.repository);

  Stream<List<Stage2LoadData>> call() {
    return repository.watch();
  }
}
