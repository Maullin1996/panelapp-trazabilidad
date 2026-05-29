// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import '../../../../../packages/core/lib/features/stage2_load/domain/entities/stage2_load_data.dart';
// import '../../../../../packages/core/lib/features/stage2_load/domain/repositories/stage2_repository.dart';
// import '../../../../../packages/core/lib/features/stage2_load/domain/usecases/index.dart';

// class MockStage2Repository extends Mock implements Stage2Repository {}

// class FakeStage2LoadData extends Fake implements Stage2LoadData {}

// void main() {
//   late MockStage2Repository mockRepository;

//   final tData = Stage2LoadData(
//     id: 'test-id',
//     projectId: 'project-123',
//     date: DateTime(2024),
//     baskets: BasketLoadData(referenceWeight: 12.5, count: 5, realWeight: 11.8),
//   );

//   setUpAll(() {
//     registerFallbackValue(FakeStage2LoadData());
//   });

//   setUp(() {
//     mockRepository = MockStage2Repository();
//   });

//   group('CreateStage2Data', () {
//     test('llama a repository.create', () async {
//       when(() => mockRepository.create(any())).thenAnswer((_) async {});

//       await CreateStage2Data(mockRepository)(tData);

//       verify(() => mockRepository.create(tData)).called(1);
//     });
//   });
//   group('UpdateStage2Data', () {
//     test('llama a repository.update', () async {
//       when(() => mockRepository.update(any())).thenAnswer((_) async {});

//       await UpdateStage2Data(mockRepository)(tData);

//       verify(() => mockRepository.update(tData)).called(1);
//     });
//   });
//   group('DeleteStage2Data', () {
//     test('llama a repository.delete con el id correcto', () async {
//       when(() => mockRepository.delete(any())).thenAnswer((_) async {});

//       await DeleteStage2Data(mockRepository)('test-id');

//       verify(() => mockRepository.delete('test-id')).called(1);
//     });
//   });
//   group('WatchStage2Load', () {
//     test('retorna el stream del repositorio', () async {
//       final loads = [tData];
//       when(() => mockRepository.watch()).thenAnswer((_) => Stream.value(loads));

//       final result = await WatchStage2Load(mockRepository)().first;

//       expect(result, loads);
//     });
//   });
// }
