import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';

class Stage52RecordModel {
  final String id;
  final String projectId;
  final double gaveraWeight;
  final double panelaWeight;
  final int unitCount;
  final BasketQuality quality;
  final String photoPath;
  final DateTime date;

  Stage52RecordModel({
    required this.id,
    required this.projectId,
    required this.gaveraWeight,
    required this.panelaWeight,
    required this.unitCount,
    required this.quality,
    required this.photoPath,
    required this.date,
  });

  /// Convierte de la entidad de dominio a este modelo
  factory Stage52RecordModel.fromEntity(Stage52RecordData data) {
    return Stage52RecordModel(
      id: data.id,
      projectId: data.projectId,
      gaveraWeight: data.gaveraWeight,
      panelaWeight: data.panelaWeight,
      unitCount: data.unitCount,
      quality: data.quality,
      photoPath: data.photoPath,
      date: data.date,
    );
  }

  /// Convierte de este modelo a la entidad de dominio
  Stage52RecordData toEntity() {
    return Stage52RecordData(
      id: id,
      projectId: projectId,
      gaveraWeight: gaveraWeight,
      panelaWeight: panelaWeight,
      unitCount: unitCount,
      quality: quality,
      photoPath: photoPath,
      date: date,
    );
  }

  /// Serializa a JSON para persistencia
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'gaveraWeight': gaveraWeight,
      'panelaWeight': panelaWeight,
      'unitCount': unitCount,
      'quality': quality.name, // guardamos el nombre del enum
      'photoPath': photoPath,
      'date': date.toIso8601String(),
    };
  }

  /// Crea este modelo desde JSON
  factory Stage52RecordModel.fromJson(Map<String, dynamic> json) {
    return Stage52RecordModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      gaveraWeight: (json['gaveraWeight'] as num).toDouble(),
      panelaWeight: (json['panelaWeight'] as num).toDouble(),
      unitCount: json['unitCount'] as int,
      quality: BasketQuality.values.firstWhere(
        (q) => q.name == (json['quality'] as String),
        orElse: () => BasketQuality.regular,
      ),
      photoPath: json['photoPath'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
