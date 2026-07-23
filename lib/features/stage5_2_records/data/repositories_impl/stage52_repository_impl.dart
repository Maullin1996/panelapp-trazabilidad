import '../datasources/stage52_firestore_datasource.dart';
import '../models/stage52_record_model.dart';
import '../../domain/entities/stage52_record_data.dart';
import '../../domain/repositories/stage52_repository.dart';

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
  Future<void> update(Stage52RecordData data) {
    final model = Stage52RecordModel.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage52RecordData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
