import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasources/stage2_firestore_datasource.dart';
import '../data/repositories_impl/stage2_repository_impl.dart';
import '../domain/repositories/stage2_repository.dart';

import '../domain/usecases/index.dart';

final stage2RepositoryProvider = Provider<Stage2Repository>((ref) {
  final datasource = Stage2FirestoreDatasource();
  return Stage2RepositoryImpl(datasource);
});

//usecases
final createStage2DataProvider = Provider<CreateStage2Data>((ref) {
  return CreateStage2Data(ref.read(stage2RepositoryProvider));
});

final updateStage2DataProvider = Provider<UpdateStage2Data>((ref) {
  return UpdateStage2Data(ref.read(stage2RepositoryProvider));
});

final watchStage2LoadsProvider = Provider<WatchStage2Load>((ref) {
  return WatchStage2Load(ref.read(stage2RepositoryProvider));
});

final deleteStage2DataProvider = Provider<DeleteStage2Data>((ref) {
  return DeleteStage2Data(ref.read(stage2RepositoryProvider));
});
