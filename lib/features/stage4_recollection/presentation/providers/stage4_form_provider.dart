import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/presentation/providers/stage4_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage4_form_provider.g.dart';

enum Stage4FormStatus { initial, submitting, success, error }

class Stage4FormState {
  final Stage4FormStatus status;
  final String? errorMessage;
  const Stage4FormState({
    this.status = Stage4FormStatus.initial,
    this.errorMessage,
  });
  Stage4FormState copyWith({Stage4FormStatus? status, String? errorMessage}) =>
      Stage4FormState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

@riverpod
class Stage4Form extends _$Stage4Form {
  @override
  Stage4FormState build() => const Stage4FormState();

  Future<void> submit(Stage4FormData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage4FormStatus.submitting);
    try {
      if (isNew) {
        final createUseCase = ref.read(createStage4DataProvider);
        await createUseCase(data);
      } else {
        final updateUseCase = ref.read(updateStage4DataProvider);
        await updateUseCase(data);
      }
      state = state.copyWith(status: Stage4FormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage4FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
