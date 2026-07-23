import '../entities/stage1_form_data.dart';

abstract class Stage1Repository {
  Future<void> create(Stage1FormData data);
  Future<void> update(Stage1FormData data);
  Future<void> delete(String id);
  Stream<List<Stage1FormData>> watch({int limit = 10});
  Future<Stage1FormData?> getById(String id);
}
