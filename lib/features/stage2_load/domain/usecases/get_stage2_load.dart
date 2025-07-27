import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/domain/repositories/stage2_repository.dart';

class GetStage2Load {
  final Stage2Repository repository;

  GetStage2Load(this.repository);

  Future<List<Stage2LoadData>> call() {
    return repository.getAll();
  }
}
