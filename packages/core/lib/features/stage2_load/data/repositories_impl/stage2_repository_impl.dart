import '../datasources/stage2_firestore_datasource.dart';
import '../models/stage2_load_model.dart';
import '../../domain/entities/stage2_load_data.dart';
import '../../domain/repositories/stage2_repository.dart';

class Stage2RepositoryImpl implements Stage2Repository {
  final Stage2FirestoreDatasource datasource;

  Stage2RepositoryImpl(this.datasource);

  @override
  Future<void> create(Stage2LoadData data) {
    final model = Stage2LoadModel.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Future<void> update(Stage2LoadData data) async {
    final model = Stage2LoadModel.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage2LoadData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
