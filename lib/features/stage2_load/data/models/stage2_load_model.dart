import 'package:registro_panela/features/stage2_load/domain/entities/stage2_load_data.dart';

class Stage2LoadModel {
  final String id;
  final String projectId;
  final DateTime date;
  final Map<String, dynamic> baskets;

  Stage2LoadModel({
    required this.id,
    required this.projectId,
    required this.date,
    required this.baskets,
  });

  /// Construye el Model a partir de tu entidad de dominio
  factory Stage2LoadModel.fromEntity(Stage2LoadData data) {
    return Stage2LoadModel(
      id: data.id,
      projectId: data.projectId,
      date: data.date,
      baskets: {
        'referenceWeight': data.baskets.referenceWeight,
        'count': data.baskets.count,
        'realWeight': data.baskets.realWeight,
      },
    );
  }

  /// Convierte el Model de vuelta a tu entidad de dominio
  Stage2LoadData toEntity() {
    return Stage2LoadData(
      id: id,
      projectId: projectId,
      date: date,
      baskets: BasketLoadData(
        referenceWeight: (baskets['referenceWeight'] as num).toDouble(),
        count: baskets['count'] as int,
        realWeight: (baskets['realWeight'] as num).toDouble(),
      ),
    );
  }

  /// Serialización a JSON (por ejemplo, para Firestore o envío HTTP)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'date': date.toIso8601String(),
      'baskets': baskets,
    };
  }

  /// Deserialización desde JSON
  factory Stage2LoadModel.fromJson(Map<String, dynamic> json) {
    return Stage2LoadModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      baskets: Map<String, dynamic>.from(json['baskets'] as Map),
    );
  }
}
