import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';

abstract class Stage3Repository {
  Future<void> create(Stage3FormData data);
  Future<void> update(Stage3FormData data);
  Future<List<Stage3FormData>> getAll();
  Future<void> delete(String id);
  Stream<List<Stage3FormData>> watch();
}
