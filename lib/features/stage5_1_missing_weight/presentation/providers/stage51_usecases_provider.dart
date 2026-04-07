import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/data/datasource/stage51_payment_datasource.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/data/repositories_impl/stage51_repository_impl.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/usecase/index.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/usecase/watch_stage51_data.dart';

final stage51RepositoryProvider = Provider<Stage51Repository>((ref) {
  final datasource = Stage51PaymentDatasource();
  return Stage51RepositoryImpl(datasource);
});

//Usecases
final createStage51DataProvider = Provider<CreateStage51Data>((ref) {
  return CreateStage51Data(ref.read(stage51RepositoryProvider));
});

final getStage51DataProvider = Provider<GetStage51Data>((ref) {
  return GetStage51Data(ref.read(stage51RepositoryProvider));
});

final deleteStage51DataProvider = Provider<DeleteStage51Data>((ref) {
  return DeleteStage51Data(ref.read(stage51RepositoryProvider));
});

final watchStage51DataProvider = Provider<WatchStage51Data>((ref) {
  return WatchStage51Data(ref.read(stage51RepositoryProvider));
});
