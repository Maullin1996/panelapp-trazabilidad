import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_load_provider.dart';

final syncStage2ProjectsProvider = Provider<List<Stage2LoadData>>((ref) {
  final asyncProjects = ref.watch(stage2LoadProvider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage2LoadData>[],
  );
});
