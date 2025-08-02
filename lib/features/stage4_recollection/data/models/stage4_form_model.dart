import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';

class Stage4FormModel {
  final String id;
  final String projectId;
  final DateTime date;
  final List<Map<String, dynamic>> returnedGaveras;
  final int returnedBaskets;
  final int returnedPreservativesJars;
  final int returnedLimeJars;

  Stage4FormModel({
    required this.id,
    required this.projectId,
    required this.date,
    required this.returnedGaveras,
    required this.returnedBaskets,
    required this.returnedPreservativesJars,
    required this.returnedLimeJars,
  });

  /// Convierte de la entidad _Stage4FormData_ a _Stage4FormModel_
  factory Stage4FormModel.fromEntity(Stage4FormData data) {
    return Stage4FormModel(
      id: data.id,
      projectId: data.projectId,
      date: data.date,
      returnedGaveras: data.returnedGaveras
          .map(
            (g) => {
              'quantity': g.quantity,
              'referenceWeight': g.referenceWeight,
            },
          )
          .toList(),
      returnedBaskets: data.returnedBaskets,
      returnedPreservativesJars: data.returnedPreservativesJars,
      returnedLimeJars: data.returnedLimeJars,
    );
  }

  /// Convierte de _Stage4FormModel_ a la entidad _Stage4FormData_
  Stage4FormData toEntity() {
    return Stage4FormData(
      id: id,
      projectId: projectId,
      date: date,
      returnedGaveras: returnedGaveras
          .map(
            (g) => ReturnedGaveras(
              quantity: g['quantity'] as int,
              referenceWeight: g['referenceWeight'] as double,
            ),
          )
          .toList(),
      returnedBaskets: returnedBaskets,
      returnedPreservativesJars: returnedPreservativesJars,
      returnedLimeJars: returnedLimeJars,
    );
  }

  /// Serializa a JSON puro
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'date': date.toIso8601String(),
      'returnedGaveras': returnedGaveras,
      'returnedBaskets': returnedBaskets,
      'returnedPreservativesJars': returnedPreservativesJars,
      'returnedLimeJars': returnedLimeJars,
    };
  }

  /// Deserializa desde JSON puro
  factory Stage4FormModel.fromJson(Map<String, dynamic> json) {
    return Stage4FormModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      returnedGaveras: List<Map<String, dynamic>>.from(json['returnedGaveras']),
      returnedBaskets: json['returnedBaskets'] as int,
      returnedPreservativesJars: json['returnedPreservativesJars'] as int,
      returnedLimeJars: json['returnedLimeJars'] as int,
    );
  }
}
