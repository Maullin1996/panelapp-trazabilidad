import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';

abstract class Stage52Repository {
  Future<void> create(Stage52RecordData data);
  Future<void> update(Stage52RecordData data);
  Future<List<Stage52RecordData>> getAll();
  Future<void> delete(String id);
  Stream<List<Stage52RecordData>> watch();
}
