import '../entities/stage3_form_data.dart';

abstract class Stage3Repository {
  Future<void> create(Stage3FormData data);
  Future<void> update(Stage3FormData data);
  Future<void> delete(String id);
  Stream<List<Stage3FormData>> watch();
}
