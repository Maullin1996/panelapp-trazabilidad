import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage2_load_form_provider.g.dart';

enum Stage2FormStatus { initial, submitting, success, error }

class Stage2FormState {
  final Stage2FormStatus status;
  final String? errorMessage;

  const Stage2FormState({
    this.status = Stage2FormStatus.initial,
    this.errorMessage,
  });

  Stage2FormState copyWith({
    Stage2LoadData? data,
    Stage2FormStatus? status,
    String? errorMessage,
  }) {
    return Stage2FormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class Stage2Form extends _$Stage2Form {
  @override
  Stage2FormState build() => const Stage2FormState();

  Future<void> submit(Stage2LoadData data, {required bool isNew}) async {
    state = state.copyWith(status: Stage2FormStatus.submitting);
    try {
      if (isNew) {
        final createUseCase = ref.read(createStage2DataProvider);
        await createUseCase(data);
      } else {
        final updateUseCase = ref.read(updateStage2DataProvider);
        await updateUseCase(data);
      }
      state = state.copyWith(status: Stage2FormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage2FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
