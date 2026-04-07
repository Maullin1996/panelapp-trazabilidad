import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_load_provider.dart';

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
