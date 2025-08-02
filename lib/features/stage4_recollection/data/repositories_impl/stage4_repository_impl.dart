import 'package:registro_panela/features/stage4_recollection/data/datasources/stage4_firestore_datasource.dart';
import 'package:registro_panela/features/stage4_recollection/data/models/stage4_form_model.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domin/repositories/stage4_repository.dart';

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
  Future<List<Stage4FormData>> getAll() async {
    final models = await datasource.getAll();
    return models.map((model) => model.toEntity()).toList();
  }
}
