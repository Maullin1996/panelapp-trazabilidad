import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/stage4_firestore_datasource.dart';
import '../data/repositories_impl/stage4_repository_impl.dart';
import '../domain/repositories/stage4_repository.dart';
import '../domain/usecases/index.dart';

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

final watchStage4DataProvider = Provider((ref) {
  return WatchStage4Data(ref.read(stage4RepositoryProvider));
});
