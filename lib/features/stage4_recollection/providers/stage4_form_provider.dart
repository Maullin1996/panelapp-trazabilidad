import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/providers/stage4_load_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage4_form_provider.g.dart';

enum Stage4FormStatus { initial, submitting, success, error }

class Stage4FormState {
  final Stage4FormData? data;
  final Stage4FormStatus status;
  final String? errorMessage;
  const Stage4FormState({
    this.data,
    this.status = Stage4FormStatus.initial,
    this.errorMessage,
  });
  Stage4FormState copyWith({
    Stage4FormData? data,
    Stage4FormStatus? status,
    String? errorMessage,
  }) => Stage4FormState(
    data: data ?? this.data,
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
      await Future.delayed(const Duration(milliseconds: 300));
      final repo = ref.read(stage4LoadProvider.notifier);
      if (isNew) {
        repo.add(data);
      } else {
        repo.update(data);
      }
      state = state.copyWith(status: Stage4FormStatus.success, data: data);
    } catch (e) {
      state = state.copyWith(
        status: Stage4FormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
