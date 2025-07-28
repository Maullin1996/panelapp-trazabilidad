import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage3_weigh/data/datasources/stage3_firestore_datasource.dart';
import 'package:registro_panela/features/stage3_weigh/data/repositories_impl/stage3_repository_impl.dart';
import 'package:registro_panela/features/stage3_weigh/domain/repositories/stage3_repository.dart';
import 'package:registro_panela/features/stage3_weigh/domain/usecase/index.dart';

final stage3RepositoryProvider = Provider<Stage3Repository>((ref) {
  final datasource = Stage3FirestoreDatasource();
  return Stage3RepositoryImpl(datasource);
});

//usecases
final createStage3DataProvider = Provider<CreateStage3Data>((ref) {
  return CreateStage3Data(ref.read(stage3RepositoryProvider));
});

final updateStage3DataProvider = Provider<UpdateStage3Data>((ref) {
  return UpdateStage3Data(ref.read(stage3RepositoryProvider));
});

final getStage3LoadsProvider = Provider<GetStage3Data>((ref) {
  return GetStage3Data(ref.read(stage3RepositoryProvider));
});
