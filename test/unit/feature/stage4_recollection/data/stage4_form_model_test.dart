// import 'package:flutter_test/flutter_test.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/data/models/stage4_form_model.dart';
// import '../../../../../packages/core/lib/features/stage4_recollection/domain/entities/stage4_form_data.dart';

// void main() {
//   final tDate = DateTime(2024, 1, 15);

//   final tGaveraMap = {'quantity': 3, 'referenceWeight': 12.5};

//   final tModel = Stage4FormModel(
//     id: 'test-id',
//     projectId: 'project-123',
//     date: tDate,
//     returnedGaveras: [tGaveraMap],
//     returnedBaskets: 5,
//     returnedPreservativesJars: 2,
//     returnedLimeJars: 1,
//   );

//   final tJson = {
//     'id': 'test-id',
//     'projectId': 'project-123',
//     'date': tDate.toIso8601String(),
//     'returnedGaveras': [tGaveraMap],
//     'returnedBaskets': 5,
//     'returnedPreservativesJars': 2,
//     'returnedLimeJars': 1,
//   };

//   group('Stage4FormModel', () {
//     test('fromJson construye el modelo correctamente', () {
//       final result = Stage4FormModel.fromJson(tJson);

//       expect(result.id, 'test-id');
//       expect(result.projectId, 'project-123');
//       expect(result.date, tDate);
//       expect(result.returnedBaskets, 5);
//       expect(result.returnedGaveras.first['quantity'], 3);
//     });

//     test('toJson serializa todos los campos', () {
//       final result = tModel.toJson();

//       expect(result['id'], 'test-id');
//       expect(result['projectId'], 'project-123');
//       expect(result['date'], tDate.toIso8601String());
//       expect(result['returnedBaskets'], 5);
//       expect(result['returnedGaveras'], isA<List>());
//     });

//     test('fromJson → toJson es reversible (round-trip)', () {
//       final fromJson = Stage4FormModel.fromJson(tJson);
//       final backToJson = fromJson.toJson();

//       expect(backToJson['id'], tJson['id']);
//       expect(backToJson['projectId'], tJson['projectId']);
//       expect(backToJson['date'], tJson['date']);
//     });

//     test('toEntity convierte al entity de dominio correctamente', () {
//       final entity = tModel.toEntity();

//       expect(entity, isA<Stage4FormData>());
//       expect(entity.id, tModel.id);
//       expect(entity.returnedGaveras.first.quantity, 3);
//       expect(entity.returnedGaveras.first.referenceWeight, 12.5);
//       expect(entity.returnedBaskets, 5);
//     });

//     test('fromEntity construye el modelo desde el entity', () {
//       final entity = Stage4FormData(
//         id: 'test-id',
//         projectId: 'project-123',
//         date: tDate,
//         returnedGaveras: [ReturnedGaveras(quantity: 3, referenceWeight: 12.5)],
//         returnedBaskets: 5,
//         returnedPreservativesJars: 2,
//         returnedLimeJars: 1,
//       );

//       final model = Stage4FormModel.fromEntity(entity);

//       expect(model.id, entity.id);
//       expect(model.returnedGaveras.first['quantity'], 3);
//       expect(model.returnedGaveras.first['referenceWeight'], 12.5);
//     });
//   });
// }
