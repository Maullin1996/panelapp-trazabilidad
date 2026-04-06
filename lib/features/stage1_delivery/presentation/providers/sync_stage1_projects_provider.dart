import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_projects_provider.dart';

final syncStage1ProjectsProvider = Provider<List<Stage1FormData>>((ref) {
  final asyncProjects = ref.watch(stage1ProjectsProvider);
  return asyncProjects.maybeWhen(
    data: (projects) => projects,
    orElse: () => <Stage1FormData>[],
  );
});
