import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_load_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final syncStage4DataProvider = Provider<List<Stage4FormData>>((ref) {
  final asyncProjects = ref.watch(stage4LoadProvider);
  return asyncProjects.maybeWhen(
    data: (data) => data,
    orElse: () => <Stage4FormData>[],
  );
});
