import 'package:registro_panela/features/stage3_weigh/data/datasources/stage3_firestore_datasource.dart';
import 'package:registro_panela/features/stage3_weigh/data/models/stage3_model.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';

class Stage3RepositoryImpl implements Stage3Repository {
  final Stage3FirestoreDatasource datasource;

  Stage3RepositoryImpl(this.datasource);

  @override
  Future<void> create(Stage3FormData data) {
    final model = Stage3Model.fromEntity(data);
    return datasource.create(model);
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Future<List<Stage3FormData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> update(Stage3FormData data) {
    final model = Stage3Model.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage3FormData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
