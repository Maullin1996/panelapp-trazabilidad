import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:core/features/stage1_delivery/domain/repositories/stage1_repository.dart';
import 'package:core/features/stage1_delivery/domain/usecases/index.dart';
import 'package:core/features/stage1_delivery/domain/usecases/watch_stage1_projects.dart';

class MockStage1Repository extends Mock implements Stage1Repository {}

class FakeStage1FormData extends Fake implements Stage1FormData {}

void main() {
  late MockStage1Repository mockRepository;

  final tData = Stage1FormData(
    id: 'test-id',
    name: 'Juan',
    gaveras: [],
    baskets: [],
    preservativesWeight: 0,
    preservativesJars: 0,
    limeWeight: 0,
    limeJars: 0,
    phone: '',
    date: DateTime(2024),
  );

  setUp(() {
    mockRepository = MockStage1Repository();
  });

  setUpAll(() {
    registerFallbackValue(FakeStage1FormData());
  });

  group('CreateStage1Data', () {
    test('llama a repository.create', () async {
      when(() => mockRepository.create(any())).thenAnswer((_) async {});

      await CreateStage1Data(mockRepository)(tData);

      verify(() => mockRepository.create(tData)).called(1);
    });
  });

  group('UpdateStage1Data', () {
    test('llama a repository.update', () async {
      when(() => mockRepository.update(any())).thenAnswer((_) async {});

      await UpdateStage1Data(mockRepository)(tData);

      verify(() => mockRepository.update(tData)).called(1);
    });
  });

  group('DeleteStage1Data', () {
    test('llama a repository.delete con el id correcto', () async {
      when(() => mockRepository.delete(any())).thenAnswer((_) async {});

      await DeleteStage1Data(mockRepository)('test-id');

      verify(() => mockRepository.delete('test-id')).called(1);
    });
  });

  group('WatchStage1Projects', () {
    test('retorna el stream del repositorio', () async {
      final projects = [tData];
      when(
        () => mockRepository.watch(limit: any(named: 'limit')),
      ).thenAnswer((_) => Stream.value(projects));

      final result = await WatchStage1Projects(mockRepository)().first;

      expect(result, projects);
    });
  });
}
