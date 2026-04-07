// StateNotifier para lista de PaymentData
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage51_notifier_provider.g.dart';

@riverpod
Stream<List<PaymentData>> stage51Notifier(Ref ref) {
  final usecase = ref.watch(watchStage51DataProvider);
  return usecase();
}

// @riverpod
// class Stage51Notifier extends _$Stage51Notifier {
//   @override
//   Future<List<PaymentData>> build() async {
//     final usecase = ref.read(getStage51DataProvider);
//     return usecase();
//   }

//   void loadFromBackend(List<PaymentData> projectsFromApi) {
//     state = AsyncData(projectsFromApi);
//   }

//   void addProjectOptimistic(PaymentData project) {
//     state.whenData((projects) {
//       state = AsyncData([project, ...projects]);
//     });
//   }

//   void removeProjectOptimistic(String id) {
//     state.whenData((projects) {
//       final filteredList = projects.where((p) => p.id != id).toList();
//       state = AsyncData(filteredList);
//     });
//   }

//   void refresh() {
//     ref.invalidateSelf();
//   }
// }
