import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage1_form_data.dart';
import 'stage1_projects_provider.dart';

final syncStage1ProjectsProvider = Provider<List<Stage1FormData>>((ref) {
  final asyncProjects = ref.watch(stage1ProjectsProvider);
  return asyncProjects.maybeWhen(
    data: (projects) => projects,
    orElse: () => <Stage1FormData>[],
  );
});
