// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage52_record_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage52RecordData _$Stage52RecordDataFromJson(Map<String, dynamic> json) =>
    _Stage52RecordData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      gaveraWeight: (json['gaveraWeight'] as num).toDouble(),
      panelaWeight: (json['panelaWeight'] as num).toDouble(),
      unitCount: (json['unitCount'] as num).toInt(),
      quality: $enumDecode(_$BasketQualityEnumMap, json['quality']),
      photoPath: json['photoPath'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$Stage52RecordDataToJson(_Stage52RecordData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'gaveraWeight': instance.gaveraWeight,
      'panelaWeight': instance.panelaWeight,
      'unitCount': instance.unitCount,
      'quality': _$BasketQualityEnumMap[instance.quality]!,
      'photoPath': instance.photoPath,
      'date': instance.date.toIso8601String(),
    };

const _$BasketQualityEnumMap = {
  BasketQuality.regular: 'regular',
  BasketQuality.buena: 'buena',
  BasketQuality.negra: 'negra',
  BasketQuality.extra: 'extra',
};
