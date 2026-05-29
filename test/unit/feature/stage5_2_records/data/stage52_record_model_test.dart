// import 'package:flutter_test/flutter_test.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/data/models/stage52_record_model.dart';
// import '../../../../../packages/core/lib/features/stage5_2_records/domain/entities/stage52_record_data.dart';

// void main() {
//   final tDate = DateTime(2024, 1, 15);

//   final tModel = Stage52RecordModel(
//     id: 'test-id',
//     projectId: 'project-123',
//     gaveraWeight: 12.5,
//     panelaWeight: 50.0,
//     unitCount: 10,
//     quality: BasketQuality.buena,
//     photoPath: 'https://example.com/photo.jpg',
//     date: tDate,
//   );

//   final tJson = {
//     'id': 'test-id',
//     'projectId': 'project-123',
//     'gaveraWeight': 12.5,
//     'panelaWeight': 50.0,
//     'unitCount': 10,
//     'quality': 'buena',
//     'photoPath': 'https://example.com/photo.jpg',
//     'date': tDate.toIso8601String(),
//   };

//   group('Stage52RecordModel', () {
//     test('fromJson construye el modelo correctamente', () {
//       final result = Stage52RecordModel.fromJson(tJson);

//       expect(result.id, 'test-id');
//       expect(result.projectId, 'project-123');
//       expect(result.gaveraWeight, 12.5);
//       expect(result.unitCount, 10);
//       expect(result.quality, BasketQuality.buena);
//       expect(result.date, tDate);
//     });

//     test('toJson serializa el enum como string', () {
//       final result = tModel.toJson();

//       expect(result['id'], 'test-id');
//       expect(result['quality'], 'buena');
//       expect(result['date'], tDate.toIso8601String());
//       expect(result['unitCount'], 10);
//     });

//     test('fromJson → toJson es reversible (round-trip)', () {
//       final fromJson = Stage52RecordModel.fromJson(tJson);
//       final backToJson = fromJson.toJson();

//       expect(backToJson['id'], tJson['id']);
//       expect(backToJson['quality'], tJson['quality']);
//       expect(backToJson['date'], tJson['date']);
//     });

//     test('fromJson con quality desconocida usa fallback a regular', () {
//       final jsonWithUnknown = Map<String, dynamic>.from(tJson)
//         ..['quality'] = 'desconocida';

//       final result = Stage52RecordModel.fromJson(jsonWithUnknown);

//       expect(result.quality, BasketQuality.regular);
//     });

//     test('toEntity convierte al entity de dominio correctamente', () {
//       final entity = tModel.toEntity();

//       expect(entity, isA<Stage52RecordData>());
//       expect(entity.id, tModel.id);
//       expect(entity.quality, BasketQuality.buena);
//       expect(entity.panelaWeight, 50.0);
//     });

//     test('fromEntity construye el modelo desde el entity', () {
//       final entity = Stage52RecordData(
//         id: 'test-id',
//         projectId: 'project-123',
//         gaveraWeight: 12.5,
//         panelaWeight: 50.0,
//         unitCount: 10,
//         quality: BasketQuality.buena,
//         photoPath: 'https://example.com/photo.jpg',
//         date: tDate,
//       );

//       final model = Stage52RecordModel.fromEntity(entity);

//       expect(model.id, entity.id);
//       expect(model.quality, BasketQuality.buena);
//       expect(model.unitCount, 10);
//     });
//   });
// }
