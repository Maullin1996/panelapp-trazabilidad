import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage4_load_provider.g.dart';

@riverpod
Stream<List<Stage4FormData>> stage4Load(Ref ref, String projectId) {
  final useCase = ref.watch(watchStage4DataProvider);
  return useCase(projectId);
}

// @riverpod
// class Stage4Load extends _$Stage4Load {
//   @override
//   Future<List<Stage4FormData>> build() async {
//     final useCase = ref.read(getStage4DataProvider);
//     return useCase();
//   }

//   void loadFromBackend(List<Stage4FormData> dataFromApi) {
//     state = AsyncData(dataFromApi);
//   }

//   void addDataOptimistic(Stage4FormData entry) {
//     state.whenData((value) {
//       state = AsyncData([...value, entry]);
//     });
//   }

//   void updateProjectOptimistic(Stage4FormData entry) {
//     state.whenData((value) {
//       final updatedList = value
//           .map((d) => d.id == entry.id ? entry : d)
//           .toList();
//       state = AsyncData(updatedList);
//     });
//   }

//   void refresh() {
//     ref.invalidateSelf();
//   }
// }
