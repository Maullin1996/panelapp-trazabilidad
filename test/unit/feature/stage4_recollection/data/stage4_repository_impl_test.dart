// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/data/datasources/stage4_firestore_datasource.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/data/models/stage4_form_model.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/data/repositories_impl/stage4_repository_impl.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/domain/entities/stage4_form_data.dart';

// class MockStage4FirestoreDatasource extends Mock
//     implements Stage4FirestoreDatasource {}

// class FakeStage4FormModel extends Fake implements Stage4FormModel {}

// void main() {
//   late MockStage4FirestoreDatasource mockDatasource;
//   late Stage4RepositoryImpl repository;

//   final tData = Stage4FormData(
//     id: 'test-id',
//     projectId: 'project-123',
//     date: DateTime(2024, 1, 1),
//     returnedGaveras: [ReturnedGaveras(quantity: 3, referenceWeight: 12.5)],
//     returnedBaskets: 5,
//     returnedPreservativesJars: 2,
//     returnedLimeJars: 1,
//   );

//   setUpAll(() {
//     registerFallbackValue(FakeStage4FormModel());
//   });

//   setUp(() {
//     mockDatasource = MockStage4FirestoreDatasource();
//     repository = Stage4RepositoryImpl(mockDatasource);
//   });

//   group('Stage4RepositoryImpl', () {
//     test('create llama al datasource con el modelo correcto', () async {
//       when(() => mockDatasource.create(any())).thenAnswer((_) async {});

//       await repository.create(tData);

//       final captured =
//           verify(() => mockDatasource.create(captureAny())).captured.first
//               as Stage4FormModel;

//       expect(captured.id, tData.id);
//       expect(captured.projectId, tData.projectId);
//     });

//     test('update llama al datasource con el modelo correcto', () async {
//       when(() => mockDatasource.update(any())).thenAnswer((_) async {});

//       await repository.update(tData);

//       verify(() => mockDatasource.update(any())).called(1);
//     });

//     test('watch filtra por projectId y convierte a entities', () async {
//       final models = [
//         Stage4FormModel(
//           id: 'test-id',
//           projectId: 'project-123',
//           date: DateTime(2024),
//           returnedGaveras: [
//             {'quantity': 3, 'referenceWeight': 12.5},
//           ],
//           returnedBaskets: 5,
//           returnedPreservativesJars: 2,
//           returnedLimeJars: 1,
//         ),
//       ];

//       when(
//         () => mockDatasource.watchAll(any()),
//       ).thenAnswer((_) => Stream.value(models));

//       final result = await repository.watch('project-123').first;

//       verify(() => mockDatasource.watchAll('project-123')).called(1);
//       expect(result, isA<List<Stage4FormData>>());
//       expect(result.first.id, 'test-id');
//       expect(result.first.returnedBaskets, 5);
//     });
//   });
// }
