import 'package:registro_panela/features/stage5_2_records/data/datasources/stage52_firestore_datasource.dart';
import 'package:registro_panela/features/stage5_2_records/data/models/stage52_record_model.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';

class Stage52RepositoryImpl implements Stage52Repository {
  final Stage52FirestoreDatasource datasource;

  Stage52RepositoryImpl(this.datasource);

  @override
  Future<void> create(Stage52RecordData data) {
    final model = Stage52RecordModel.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Future<List<Stage52RecordData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> update(Stage52RecordData data) {
    final model = Stage52RecordModel.fromEntity(data);
    return datasource.update(model);
  }
}
