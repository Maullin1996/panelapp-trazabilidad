import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/stage3_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage3_load_provider.g.dart';

@riverpod
Stream<List<Stage3FormData>> stage3Load(Ref ref) {
  final usecase = ref.read(watchStatage3LoadsProvider);
  return usecase();
}

// @riverpod
// class Stage3Load extends _$Stage3Load {
//   @override
//   Future<List<Stage3FormData>> build() async {
//     final usecase = ref.read(getStage3LoadsProvider);
//     return await usecase();
//   }

//   void loadFromBackend(List<Stage3FormData> loadsFromApi) {
//     state = AsyncData(loadsFromApi);
//   }

//   void addProjectOptimistic(Stage3FormData updatedLoad) {
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
