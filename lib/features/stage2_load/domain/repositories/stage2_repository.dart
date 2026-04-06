import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';

abstract class Stage2Repository {
  Future<void> create(Stage2LoadData data);
  Future<void> update(Stage2LoadData data);
  Future<List<Stage2LoadData>> getAll();
  Future<void> delete(String id);
  Stream<List<Stage2LoadData>> watch();
}
