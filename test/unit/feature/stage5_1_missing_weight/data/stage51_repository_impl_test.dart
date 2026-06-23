import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/stage5_1_missing_weight/domain/entities/payment_data.dart';
import 'package:core/features/stage5_1_missing_weight/domain/repositories/stage51_repository.dart';
import 'package:core/features/stage5_1_missing_weight/domain/usecase/create_stage51_data.dart';
import 'package:core/features/stage5_1_missing_weight/domain/usecase/delete_stage51_data.dart';
import 'package:core/features/stage5_1_missing_weight/domain/usecase/watch_stage51_data.dart';

class MockStage51Repository extends Mock implements Stage51Repository {}

class FakePaymentData extends Fake implements PaymentData {}

void main() {
  late MockStage51Repository mockRepository;

  final tData = PaymentData(
    id: 'test-id',
    projectId: 'project-123',
    date: DateTime(2024),
    amount: 150.75,
  );

  setUpAll(() {
    registerFallbackValue(FakePaymentData());
  });

  setUp(() {
    mockRepository = MockStage51Repository();
  });

  group('CreateStage51Data', () {
    test('llama a repository.create', () async {
      when(() => mockRepository.create(any())).thenAnswer((_) async {});

      await CreateStage51Data(mockRepository)(tData);

      verify(() => mockRepository.create(tData)).called(1);
    });
  });

  group('DeleteStage51Data', () {
    test('llama a repository.delete con el id correcto', () async {
      when(() => mockRepository.delete(any())).thenAnswer((_) async {});

      await DeleteStage51Data(mockRepository)('test-id');

      verify(() => mockRepository.delete('test-id')).called(1);
    });
  });

  group('WatchStage51Data', () {
    test('retorna el stream del repositorio', () async {
      final payments = [tData];
      when(
        () => mockRepository.watch(),
      ).thenAnswer((_) => Stream.value(payments));

      final result = await WatchStage51Data(mockRepository)().first;

      expect(result, payments);
    });
  });
}
