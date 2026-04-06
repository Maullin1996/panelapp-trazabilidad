import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_notifier_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/presentation/providers/stage51_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage5_price_form_state_provider.g.dart';

enum Stage5PriceFormStatus { initial, submitting, success, error }

class Stage5PriceFormState {
  final Stage5PriceFormStatus status;
  final String? errorMessage;

  const Stage5PriceFormState({
    this.status = Stage5PriceFormStatus.initial,
    this.errorMessage,
  });

  Stage5PriceFormState copyWith({
    Stage5PriceFormStatus? status,
    String? errorMessage,
  }) {
    return Stage5PriceFormState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class Stage5PriceForm extends _$Stage5PriceForm {
  @override
  Stage5PriceFormState build() => const Stage5PriceFormState();

  Future<void> submit({required PaymentData data}) async {
    state = state.copyWith(status: Stage5PriceFormStatus.submitting);

    try {
      final createUseCase = ref.read(createStage51DataProvider);
      await createUseCase(data);

      ref.read(stage51NotifierProvider.notifier).refresh();

      state = state.copyWith(status: Stage5PriceFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: Stage5PriceFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
