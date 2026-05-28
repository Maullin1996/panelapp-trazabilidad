import '../datasources/stage1_firestore_datasource.dart';
import '../models/stage1_form_model.dart';
import '../../domain/entities/stage1_form_data.dart';
import '../../domain/repositories/stage1_repository.dart';

class Stage1RepositoryImpl implements Stage1Repository {
  final Stage1FirestoreDatasource datasource;

  Stage1RepositoryImpl(this.datasource);

  @override
  Future<void> create(Stage1FormData data) {
    final model = Stage1FormModel.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Future<void> update(Stage1FormData data) {
    final model = Stage1FormModel.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage1FormData>> watch({int limit = 10}) {
    return datasource
        .watchAll(limit: limit)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
