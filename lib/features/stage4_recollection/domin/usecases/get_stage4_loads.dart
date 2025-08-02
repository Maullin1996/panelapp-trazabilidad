import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domin/repositories/stage4_repository.dart';

class GetStage4Loads {
  final Stage4Repository repository;

  GetStage4Loads(this.repository);

  Future<List<Stage4FormData>> call() {
    return repository.getAll();
  }
}
