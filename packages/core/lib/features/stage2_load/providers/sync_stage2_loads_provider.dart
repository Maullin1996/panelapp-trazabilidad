import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage2_load_data.dart';
import 'stage2_load_provider.dart';

final syncStage2ProjectsProvider = Provider<List<Stage2LoadData>>((ref) {
  final asyncProjects = ref.watch(stage2LoadProvider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage2LoadData>[],
  );
});
