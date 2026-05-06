import 'package:registro_panela/features/stage4_recollection/domain/entities/stage4_form_data.dart';

abstract class Stage4Repository {
  Future<void> create(Stage4FormData data);
  Future<void> update(Stage4FormData data);
  Stream<List<Stage4FormData>> watch(String projectId);
}
