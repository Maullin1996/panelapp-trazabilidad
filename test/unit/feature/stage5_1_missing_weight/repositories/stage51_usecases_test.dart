import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/stage5_1_missing_weight/data/datasource/stage51_payment_datasource.dart';
import 'package:core/features/stage5_1_missing_weight/data/models/stage51_payment_data_model.dart';
import 'package:core/features/stage5_1_missing_weight/data/repositories_impl/stage51_repository_impl.dart';
import 'package:core/features/stage5_1_missing_weight/domain/entities/payment_data.dart';

class MockStage51PaymentDatasource extends Mock
    implements Stage51PaymentDatasource {}

class FakePaymentDataModel extends Fake implements PaymentDataModel {}

void main() {
  late MockStage51PaymentDatasource mockDatasource;
  late Stage51RepositoryImpl repository;

  final tData = PaymentData(
    id: 'test-id',
    projectId: 'project-123',
    date: DateTime(2024),
    amount: 150.75,
  );

  setUpAll(() {
    registerFallbackValue(FakePaymentDataModel());
  });

  setUp(() {
    mockDatasource = MockStage51PaymentDatasource();
    repository = Stage51RepositoryImpl(mockDatasource);
  });

  group('Stage51RepositoryImpl', () {
    test('create llama al datasource con el modelo correcto', () async {
      when(() => mockDatasource.create(any())).thenAnswer((_) async {});

      await repository.create(tData);

      final captured =
          verify(() => mockDatasource.create(captureAny())).captured.first
              as PaymentDataModel;

      expect(captured.id, tData.id);
      expect(captured.amount, tData.amount);
    });

    test('delete llama al datasource con el id correcto', () async {
      when(() => mockDatasource.delete(any())).thenAnswer((_) async {});

      await repository.delete('test-id');

      verify(() => mockDatasource.delete('test-id')).called(1);
    });

    test('watch convierte los modelos a entities', () async {
      final models = [
        PaymentDataModel(
          id: 'test-id',
          projectId: 'project-123',
          date: DateTime(2024).toIso8601String(),
          amount: 150.75,
        ),
      ];

      when(
        () => mockDatasource.watchAll(),
      ).thenAnswer((_) => Stream.value(models));

      final result = await repository.watch().first;

      expect(result, isA<List<PaymentData>>());
      expect(result.first.id, 'test-id');
      expect(result.first.amount, 150.75);
    });
  });
}
