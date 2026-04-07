import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_load_provider.dart';

final syncStage4DataProvider = Provider.family<List<Stage4FormData>, String>((
  ref,
  projectId,
) {
  final asyncProjects = ref.watch(stage4LoadProvider(projectId));
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage4FormData>[],
  );
});
