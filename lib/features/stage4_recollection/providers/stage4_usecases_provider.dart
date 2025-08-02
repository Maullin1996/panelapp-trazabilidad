import 'package:registro_panela/features/stage4_recollection/data/datasources/stage4_firestore_datasource.dart';
import 'package:registro_panela/features/stage4_recollection/data/repositories_impl/stage4_repository_impl.dart';
import 'package:registro_panela/features/stage4_recollection/domin/repositories/stage4_repository.dart';
import 'package:registro_panela/features/stage4_recollection/domin/usecases/get_stage4_loads.dart';
import 'package:registro_panela/features/stage4_recollection/domin/usecases/index.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final stage4RepositoryProvider = Provider<Stage4Repository>((ref) {
  final datasource = Stage4FirestoreDatasource();
  return Stage4RepositoryImpl(datasource);
});

final createStage4DataProvider = Provider<CreateStage4Data>((ref) {
  return CreateStage4Data(ref.read(stage4RepositoryProvider));
});

final updateStage4DataProvider = Provider<UpdateStage4Data>((ref) {
  return UpdateStage4Data(ref.read(stage4RepositoryProvider));
});

final getStage4DataProvider = Provider((ref) {
  return GetStage4Loads(ref.read(stage4RepositoryProvider));
});
