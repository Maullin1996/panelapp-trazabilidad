import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_projects_provider.dart';

final stage1ProjectByIdProvider = Provider.family<Stage1FormData?, String>((
  ref,
  id,
) {
  final asyncProjects = ref.watch(stage1ProjectsProvider);

  return asyncProjects.maybeWhen(
    data: (projects) => projects.firstWhereOrNull((p) => p.id == id),
    orElse: () => null,
  );
});
