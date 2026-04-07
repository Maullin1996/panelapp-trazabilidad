import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/presentation/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage2_load_provider.g.dart';

@riverpod
Stream<List<Stage2LoadData>> stage2Load(Ref ref) {
  final usecase = ref.watch(watchStage2LoadsProvider);
  return usecase();
}

// @riverpod
// class Stage2Load extends _$Stage2Load {
//   @override
//   Future<List<Stage2LoadData>> build() async {
//     final usecase = ref.read(getStage2LoadsProvider);
//     return await usecase();
//   }

//   void loadFromBackend(List<Stage2LoadData> loadsFromApi) {
//     state = AsyncData(loadsFromApi);
//   }

//   void addProjectOptimistic(Stage2LoadData updatedLoad) {
//     state.whenData((loads) {
//       final updatedList = loads
//           .map((l) => l.id == updatedLoad.id ? updatedLoad : l)
//           .toList();
//       state = AsyncData(updatedList);
//     });
//   }

//   void removeProjectOptimistic(String id) {
//     state.whenData((loads) {
//       final filteredList = loads.where((l) => l.id != id).toList();
//       state = AsyncData(filteredList);
//     });
//   }

//   void refresh() {
//     ref.invalidateSelf();
//   }
// }
