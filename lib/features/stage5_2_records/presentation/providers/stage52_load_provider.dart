import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';
import 'package:registro_panela/features/stage5_2_records/presentation/providers/stage52_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage52_load_provider.g.dart';

@riverpod
Stream<List<Stage52RecordData>> stage52Load(Ref ref) {
  final usecase = ref.watch(watchStage52ProjectsProvider);
  return usecase();
}

// @riverpod
// class Stage52Load extends _$Stage52Load {
//   @override
//   Future<List<Stage52RecordData>> build() async {
//     final usecase = ref.read(getStage52ProjectsProvider);
//     return usecase();
//   }

//   void loadFromBackend(List<Stage52RecordData> dataFromApi) {
//     state = AsyncData(dataFromApi);
//   }

//   void addLoadOptimistic(Stage52RecordData load) {
//     state.whenData((loads) {
//       state = AsyncData([load, ...loads]);
//     });
//   }

//   void updateLoadOptimistic(Stage52RecordData updateLoad) {
//     state.whenData((loads) {
//       final updatedList = loads
//           .map((p) => p.id == updateLoad.id ? updateLoad : p)
//           .toList();
//       state = AsyncData(updatedList);
//     });
//   }

//   void removeProjectOptimistic(String id) {
//     state.whenData((loads) {
//       final filteredList = loads.where((p) => p.id != id).toList();
//       state = AsyncData(filteredList);
//     });
//   }

//   void refresh() {
//     ref.invalidateSelf();
//   }
// }
