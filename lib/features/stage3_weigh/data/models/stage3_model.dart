import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';

class Stage3Model {
  final String id;
  final String projectId;
  final String stage2LoadId;
  final DateTime date;
  final List<Map<String, dynamic>> baskets;

  Stage3Model({
    required this.id,
    required this.projectId,
    required this.stage2LoadId,
    required this.date,
    required this.baskets,
  });

  factory Stage3Model.fromEntity(Stage3FormData data) {
    return Stage3Model(
      id: data.id,
      projectId: data.projectId,
      stage2LoadId: data.stage2LoadId,
      date: data.date,
      baskets: data.baskets
          .map(
            (b) => {
              'id': b.id,
              'sequence': b.sequence,
              'referenceWeight': b.referenceWeight,
              'realWeight': b.realWeight,
              'quality': b.quality.name,
              'photoPath': b.photoPath,
            },
          )
          .toList(),
    );
  }

  Stage3FormData toEntity() {
    return Stage3FormData(
      id: id,
      projectId: projectId,
      stage2LoadId: stage2LoadId,
      date: date,
      baskets: baskets.map((m) {
        return BasketWeighData.fromJson({
          'id': (m['id'] as String?) ?? '',
          'sequence': (m['sequence'] as int?) ?? 0,
          'referenceWeight': (m['referenceWeight'] as num?)?.toDouble() ?? 0.0,
          'realWeight': (m['realWeight'] as num?)?.toDouble() ?? 0.0,
          'quality': (m['quality'] as String?) ?? 'regular',
          'photoPath': (m['photoPath'] as String?) ?? '',
        });
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'stage2LoadId': stage2LoadId,
      'date': date.toIso8601String(),
      'baskets': baskets,
    };
  }

  factory Stage3Model.fromJson(Map<String, dynamic> json) {
    return Stage3Model(
      id: (json['id'] as String?) ?? '',
      projectId: (json['projectId'] as String?) ?? '',
      stage2LoadId: (json['stage2LoadId'] as String?) ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      baskets: json['baskets'] != null
          ? List<Map<String, dynamic>>.from(json['baskets'] as List)
          : [],
    );
  }
}
