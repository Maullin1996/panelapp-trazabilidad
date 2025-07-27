import 'package:registro_panela/features/stage2_load/data/datasources/stage2_firestore_datasource.dart';
import 'package:registro_panela/features/stage2_load/data/models/stage2_load_model.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/domain/repositories/stage2_repository.dart';

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
  Future<List<Stage2LoadData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> update(Stage2LoadData data) async {
    final model = Stage2LoadModel.fromEntity(data);
    return datasource.update(model);
  }
}
