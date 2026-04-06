import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/data/datasources/stage1_firestore_datasource.dart';
import 'package:registro_panela/features/stage1_delivery/data/repositories_impl/stage1_repository_impl.dart';
import 'package:registro_panela/features/stage1_delivery/domain/repositories/stage1_repository.dart';
import 'package:registro_panela/features/stage1_delivery/domain/usecases/index.dart';
import 'package:registro_panela/features/stage1_delivery/domain/usecases/watch_stage1_projects.dart';

final stage1RepositoryProvider = Provider<Stage1Repository>((ref) {
  final datasource = Stage1FirestoreDatasource();
  return Stage1RepositoryImpl(datasource);
});

//Usecases
final createStage1DataProvider = Provider<CreateStage1Data>((ref) {
  return CreateStage1Data(ref.read(stage1RepositoryProvider));
});

final updateStage1DataProvider = Provider<UpdateStage1Data>((ref) {
  return UpdateStage1Data(ref.read(stage1RepositoryProvider));
});

final getStage1ProjectsProvider = Provider<GetStage1Projects>((ref) {
  return GetStage1Projects(ref.read(stage1RepositoryProvider));
});

final watchStage1ProjectsProvider = Provider<WatchStage1Projects>((ref) {
  return WatchStage1Projects(ref.read(stage1RepositoryProvider));
});

final deleteStage1DataProvider = Provider<DeleteStage1Data>((ref) {
  return DeleteStage1Data(ref.read(stage1RepositoryProvider));
});
