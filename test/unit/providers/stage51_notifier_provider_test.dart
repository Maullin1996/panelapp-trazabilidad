import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/domain/usecase/get_stage51_data.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage51_notifier_provider.dart';
import 'package:registro_panela/features/stage5_1_missing_weight/providers/stage51_usecases_provider.dart';

class _FakeStage51Repository implements Stage51Repository {
  _FakeStage51Repository(this._data);

  List<PaymentData> _data;

  @override
  Future<List<PaymentData>> getAll() async => _data;

  @override
  Future<void> create(PaymentData data) async {}

  @override
  Future<void> delete(String id) async {}
}

PaymentData _payment(String id, double amount) {
  return PaymentData(
    id: id,
    projectId: 'p1',
    date: DateTime(2024, 1, 1),
    amount: amount,
  );
}

void main() {
  test('Stage51Notifier builds from usecase data', () async {
    final initial = [_payment('a', 10)];
    final repo = _FakeStage51Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage51DataProvider.overrideWithValue(GetStage51Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final value = await container.read(stage51NotifierProvider.future);
    expect(value, initial);
  });

  test('Stage51Notifier optimistic add/remove', () async {
    final initial = [_payment('a', 10), _payment('b', 20)];
    final repo = _FakeStage51Repository(initial);

    final container = ProviderContainer(
      overrides: [
        getStage51DataProvider.overrideWithValue(GetStage51Data(repo)),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(stage51NotifierProvider.notifier);
    await container.read(stage51NotifierProvider.future);

    notifier.addProjectOptimistic(_payment('c', 30));
    final afterAdd = container.read(stage51NotifierProvider).requireValue;
    expect(afterAdd.first.id, 'c');

    notifier.removeProjectOptimistic('b');
    final afterRemove = container.read(stage51NotifierProvider).requireValue;
    expect(afterRemove.any((e) => e.id == 'b'), false);
  });
}