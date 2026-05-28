import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage3_form_data.dart';
import 'stage3_load_provider.dart';

final syncStage3ProjectsProvider = Provider<List<Stage3FormData>>((ref) {
  final asyncProjects = ref.watch(stage3LoadProvider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage3FormData>[],
  );
});
