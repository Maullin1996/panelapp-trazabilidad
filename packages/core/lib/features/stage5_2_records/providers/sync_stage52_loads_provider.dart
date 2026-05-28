import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage52_record_data.dart';
import 'stage52_load_provider.dart';

final syncStage52LoadsProvider = Provider<List<Stage52RecordData>>((ref) {
  final asyncLoads = ref.watch(stage52LoadProvider);
  return asyncLoads.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage52RecordData>[],
  );
});

final stage52ByProjectProvider =
    Provider.family<List<Stage52RecordData>, String>((ref, projectId) {
      return ref
          .watch(syncStage52LoadsProvider)
          .where((r) => r.projectId == projectId)
          .toList();
    });
// En sync_stage52_loads_provider.dart agrega:
final stage52LoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage52LoadProvider).isLoading;
});
