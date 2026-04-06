import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_projects_provider.dart';

final stage1ProjectsErrorProvider = Provider<String?>((ref) {
  final asyncProjects = ref.watch(stage1ProjectsProvider);
  return asyncProjects.maybeWhen(
    error: (error, _) => error.toString(),
    orElse: () => null,
  );
});
