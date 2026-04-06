import 'package:registro_panela/features/stage1_delivery/data/datasources/stage1_firestore_datasource.dart';
import 'package:registro_panela/features/stage1_delivery/data/models/stage1_form_model.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/domain/repositories/stage1_repository.dart';

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
  Future<List<Stage1FormData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> update(Stage1FormData data) {
    final model = Stage1FormModel.fromEntity(data);
    return datasource.update(model);
  }

  @override
  Stream<List<Stage1FormData>> watch() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }
}
