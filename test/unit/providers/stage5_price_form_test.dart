import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/usecase/create_stage51_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage51_usecases_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage5_price_form_state_provider.dart';

class _FakeStage51Repository implements Stage51Repository {
  PaymentData? lastCreated;
  bool shouldThrow = false;

  @override
  Future<void> create(PaymentData data) async {
    if (shouldThrow) throw Exception('create failed');
    lastCreated = data;
  }

  @override
  Future<List<PaymentData>> getAll() async => [];

  @override
  Future<void> delete(String id) async {}
}

PaymentData _payment(String id) {
  return PaymentData(
    id: id,
    projectId: 'p1',
    date: DateTime(2024, 1, 1),
    amount: 10,
  );
}

void main() {
  test(
    'Stage5PriceForm submit success updates status and refreshes list',
    () async {
      final repo = _FakeStage51Repository();

      final container = ProviderContainer(
        overrides: [
          createStage51DataProvider.overrideWithValue(CreateStage51Data(repo)),
        ],
      );
      addTearDown(container.dispose);

      final form = container.read(stage5PriceFormProvider.notifier);

      await form.submit(data: _payment('a'));

      final state = container.read(stage5PriceFormProvider);
      expect(state.status, Stage5PriceFormStatus.success);
      expect(repo.lastCreated?.id, 'a');
    },
  );

  test('Stage5PriceForm submit error sets error status', () async {
    final repo = _FakeStage51Repository()..shouldThrow = true;

    final container = ProviderContainer(
      overrides: [
        createStage51DataProvider.overrideWithValue(CreateStage51Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final form = container.read(stage5PriceFormProvider.notifier);

    await form.submit(data: _payment('a'));

    final state = container.read(stage5PriceFormProvider);
    expect(state.status, Stage5PriceFormStatus.error);
    expect(state.errorMessage, contains('create failed'));
  });
}
