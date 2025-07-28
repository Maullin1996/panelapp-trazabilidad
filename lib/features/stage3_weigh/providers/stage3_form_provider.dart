import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'stage3_form_provider.g.dart';

enum Stage3FormStatus { initial, submitting, success, error }

class Stage3FormState {
  final Stage3FormData? data;
  final Stage3FormStatus status;
  final String? errorMessage;
  const Stage3FormState({
    this.data,
    this.status = Stage3FormStatus.initial,
    this.errorMessage,
  });
  Stage3FormState copyWith({
    Stage3FormData? data,
    Stage3FormStatus? status,
    String? errorMessage,
  }) => Stage3FormState(
    data: data ?? this.data,
    status: status ?? this.status,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}

@riverpod
class Stage3Form extends _$Stage3Form {
  @override
  Stage3FormState build() => const Stage3FormState();

  Future<void> submit(Stage3FormData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage3FormStatus.submitting);
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final repo = ref.read(stage3LoadProvider.notifier);
      if (isNew) {
        repo.add(data);
      } else {
        repo.update(data);
      }

      state = state.copyWith(status: Stage3FormStatus.success, data: data);
    } catch (e) {
      state = state.copyWith(
        status: Stage3FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
