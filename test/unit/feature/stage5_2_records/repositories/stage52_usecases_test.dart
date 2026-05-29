// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/entities/stage52_record_data.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/repositories/stage52_repository.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/usecases/create_stage52_data.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/usecases/delete_stage52_data.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/usecases/update_stage52_data.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/usecases/watch_stage52_data.dart';

// class MockStage52Repository extends Mock implements Stage52Repository {}

// class FakeStage52RecordData extends Fake implements Stage52RecordData {}

// void main() {
//   late MockStage52Repository mockRepository;

//   final tData = Stage52RecordData(
//     id: 'test-id',
//     projectId: 'project-123',
//     gaveraWeight: 12.5,
//     panelaWeight: 50.0,
//     unitCount: 10,
//     quality: BasketQuality.buena,
//     photoPath: '',
//     date: DateTime(2024),
//   );

//   setUpAll(() {
//     registerFallbackValue(FakeStage52RecordData());
//   });

//   setUp(() {
//     mockRepository = MockStage52Repository();
//   });

//   group('CreateStage52Data', () {
//     test('llama a repository.create', () async {
//       when(() => mockRepository.create(any())).thenAnswer((_) async {});

//       await CreateStage52Data(mockRepository)(tData);

//       verify(() => mockRepository.create(tData)).called(1);
//     });
//   });

//   group('UpdateStage52Data', () {
//     test('llama a repository.update', () async {
//       when(() => mockRepository.update(any())).thenAnswer((_) async {});

//       await UpdateStage52Data(mockRepository)(tData);

//       verify(() => mockRepository.update(tData)).called(1);
//     });
//   });

//   group('DeleteStage52Data', () {
//     test('llama a repository.delete con el id correcto', () async {
//       when(() => mockRepository.delete(any())).thenAnswer((_) async {});

//       await DeleteStage52Data(mockRepository)('test-id');

//       verify(() => mockRepository.delete('test-id')).called(1);
//     });
//   });

//   group('WatchStage52Data', () {
//     test('retorna el stream del repositorio', () async {
//       final records = [tData];
//       when(
//         () => mockRepository.watch(),
//       ).thenAnswer((_) => Stream.value(records));

//       final result = await WatchStage52Data(mockRepository)().first;

//       expect(result, records);
//     });
//   });
// }
