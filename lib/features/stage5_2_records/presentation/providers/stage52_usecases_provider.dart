import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/data/datasources/stage52_firestore_datasource.dart';
import 'package:registro_panela/features/stage5_2_records/data/repositories_impl/stage52_repository_impl.dart';
import 'package:registro_panela/features/stage5_2_records/domain/repositories/stage52_repository.dart';
import 'package:registro_panela/features/stage5_2_records/domain/usecases/index.dart';

final stage52RepositoryProvider = Provider<Stage52Repository>((ref) {
  final datasource = Stage52FirestoreDatasource();
  return Stage52RepositoryImpl(datasource);
});

//Usecases
// ✅ Después
final createStage52DataProvider = Provider<CreateStage52Data>((ref) {
  return CreateStage52Data(ref.watch(stage52RepositoryProvider));
});

final updateStage52DataProvider = Provider<UpdateStage52Data>((ref) {
  return UpdateStage52Data(ref.watch(stage52RepositoryProvider));
});

final getStage52ProjectsProvider = Provider<GetStage52Data>((ref) {
  return GetStage52Data(ref.watch(stage52RepositoryProvider));
});

final deleteStage52DataProvider = Provider<DeleteStage52Data>((ref) {
  return DeleteStage52Data(ref.watch(stage52RepositoryProvider));
});

final watchStage52ProjectsProvider = Provider<WatchStage52Data>((ref) {
  return WatchStage52Data(ref.watch(stage52RepositoryProvider));
});
