import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/repositories/stage3_repository.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/usecase/create_stage3_data.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/usecase/delete_stage3_data.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/usecase/update_stage3_data.dart';
import '../../../../../packages/core/lib/features/stage3_weigh/domain/usecase/watch_stage3_weighs.dart';

class MockStage3Repository extends Mock implements Stage3Repository {}

class FakeStage3FormData extends Fake implements Stage3FormData {}

void main() {
  late MockStage3Repository mockRepository;

  final tData = Stage3FormData(
    id: 'test-id',
    projectId: 'project-123',
    stage2LoadId: 'load-456',
    date: DateTime(2024),
    baskets: [
      BasketWeighData(
        id: 'basket-1',
        sequence: 1,
        referenceWeight: 12.5,
        realWeight: 11.8,
        quality: BasketQuality.regular,
        photoPath: '',
      ),
    ],
  );

  setUpAll(() {
    registerFallbackValue(FakeStage3FormData());
  });

  setUp(() {
    mockRepository = MockStage3Repository();
  });

  group('CreateStage3Data', () {
    test('llama a repository.create', () async {
      when(() => mockRepository.create(any())).thenAnswer((_) async {});

      await CreateStage3Data(mockRepository)(tData);

      verify(() => mockRepository.create(tData)).called(1);
    });
  });

  group('UpdateStage3Data', () {
    test('llama a repository.update', () async {
      when(() => mockRepository.update(any())).thenAnswer((_) async {});

      await UpdateStage3Data(mockRepository)(tData);

      verify(() => mockRepository.update(tData)).called(1);
    });
  });

  group('DeleteStage3Data', () {
    test('llama a repository.delete con el id correcto', () async {
      when(() => mockRepository.delete(any())).thenAnswer((_) async {});

      await DeleteStage3Data(mockRepository)('test-id');

      verify(() => mockRepository.delete('test-id')).called(1);
    });
  });

  group('WatchStage3Weighs', () {
    test('retorna el stream del repositorio', () async {
      final weighs = [tData];
      when(
        () => mockRepository.watch(),
      ).thenAnswer((_) => Stream.value(weighs));

      final result = await WatchStage3Weighs(mockRepository)().first;

      expect(result, weighs);
    });
  });
}
