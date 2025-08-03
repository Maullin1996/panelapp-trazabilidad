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
final createStage52DataProvider = Provider<CreateStage52Data>((ref) {
  return CreateStage52Data(ref.read(stage52RepositoryProvider));
});

final updateStage52DataProvider = Provider<UpdateStage52Data>((ref) {
  return UpdateStage52Data(ref.read(stage52RepositoryProvider));
});

final getStage52ProjectsProvider = Provider<GetStage52Data>((ref) {
  return GetStage52Data(ref.read(stage52RepositoryProvider));
});
