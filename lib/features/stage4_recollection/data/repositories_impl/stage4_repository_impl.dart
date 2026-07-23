import '../datasources/stage4_firestore_datasource.dart';
import '../models/stage4_form_model.dart';
import '../../domain/entities/stage4_form_data.dart';
import '../../domain/repositories/stage4_repository.dart';

class Stage4RepositoryImpl implements Stage4Repository {
  final Stage4FirestoreDatasource datasource;

  Stage4RepositoryImpl(this.datasource);

  @override
  Future<void> create(Stage4FormData data) {
    final model = Stage4FormModel.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> update(Stage4FormData data) {
    final model = Stage4FormModel.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage4FormData>> watch(String projectId) {
    return datasource
        .watchAll(projectId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
