import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domain/entities/stage4_form_data.dart';
import 'package:registro_panela/features/stage4_recollection/domain/repositories/stage4_repository.dart';
import 'package:registro_panela/features/stage4_recollection/domain/usecases/create_stage4_data.dart';
import 'package:registro_panela/features/stage4_recollection/domain/usecases/update_stage4_data.dart';
import 'package:registro_panela/features/stage4_recollection/domain/usecases/watch_stage4_data.dart';

class MockStage4Repository extends Mock implements Stage4Repository {}

class FakeStage4FormData extends Fake implements Stage4FormData {}

void main() {
  late MockStage4Repository mockRepository;

  final tData = Stage4FormData(
    id: 'test-id',
    projectId: 'project-123',
    date: DateTime(2024),
    returnedGaveras: [ReturnedGaveras(quantity: 3, referenceWeight: 12.5)],
    returnedBaskets: [ReturnedBaskets(size: BasketSize.grande, quantity: 5)],
    returnedPreservativesJars: 2,
    returnedLimeJars: 1,
  );

  setUpAll(() {
    registerFallbackValue(FakeStage4FormData());
  });

  setUp(() {
    mockRepository = MockStage4Repository();
  });

  group('CreateStage4Data', () {
    test('llama a repository.create', () async {
      when(() => mockRepository.create(any())).thenAnswer((_) async {});

      await CreateStage4Data(mockRepository)(tData);

      verify(() => mockRepository.create(tData)).called(1);
    });
  });

  group('UpdateStage4Data', () {
    test('llama a repository.update', () async {
      when(() => mockRepository.update(any())).thenAnswer((_) async {});

      await UpdateStage4Data(mockRepository)(tData);

      verify(() => mockRepository.update(tData)).called(1);
    });
  });

  group('WatchStage4Data', () {
    test('retorna el stream filtrado por projectId', () async {
      final entries = [tData];
      when(
        () => mockRepository.watch(any()),
      ).thenAnswer((_) => Stream.value(entries));

      final result = await WatchStage4Data(mockRepository)('project-123').first;

      verify(() => mockRepository.watch('project-123')).called(1);
      expect(result, entries);
    });
  });
}
