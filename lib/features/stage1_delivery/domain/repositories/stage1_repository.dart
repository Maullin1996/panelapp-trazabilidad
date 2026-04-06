import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

abstract class Stage1Repository {
  Future<void> create(Stage1FormData data);
  Future<void> update(Stage1FormData data);
  Future<List<Stage1FormData>> getAll();
  Future<void> delete(String id);
  Stream<List<Stage1FormData>> watch();
}
