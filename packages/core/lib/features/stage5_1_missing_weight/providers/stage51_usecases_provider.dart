import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/stage51_payment_datasource.dart';
import '../data/repositories_impl/stage51_repository_impl.dart';
import '../domain/repositories/stage51_repository.dart';
import '../domain/usecase/index.dart';
import '../domain/usecase/watch_stage51_data.dart';

final stage51RepositoryProvider = Provider<Stage51Repository>((ref) {
  final datasource = Stage51PaymentDatasource();
  return Stage51RepositoryImpl(datasource);
});

//Usecases
final createStage51DataProvider = Provider<CreateStage51Data>((ref) {
  return CreateStage51Data(ref.read(stage51RepositoryProvider));
});

final deleteStage51DataProvider = Provider<DeleteStage51Data>((ref) {
  return DeleteStage51Data(ref.read(stage51RepositoryProvider));
});

final watchStage51DataProvider = Provider<WatchStage51Data>((ref) {
  return WatchStage51Data(ref.read(stage51RepositoryProvider));
});
