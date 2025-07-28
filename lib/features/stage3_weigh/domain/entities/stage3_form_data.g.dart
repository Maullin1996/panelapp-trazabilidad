// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage3_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BasketWeighData _$BasketWeighDataFromJson(Map<String, dynamic> json) =>
    _BasketWeighData(
      id: json['id'] as String,
      sequence: (json['sequence'] as num).toInt(),
      referenceWeight: (json['referenceWeight'] as num).toDouble(),
      realWeight: (json['realWeight'] as num).toDouble(),
      quality: $enumDecode(_$BasketQualityEnumMap, json['quality']),
      photoPath: json['photoPath'] as String,
    );

Map<String, dynamic> _$BasketWeighDataToJson(_BasketWeighData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequence': instance.sequence,
      'referenceWeight': instance.referenceWeight,
      'realWeight': instance.realWeight,
      'quality': _$BasketQualityEnumMap[instance.quality]!,
      'photoPath': instance.photoPath,
    };

const _$BasketQualityEnumMap = {
  BasketQuality.regular: 'regular',
  BasketQuality.buena: 'buena',
  BasketQuality.negra: 'negra',
  BasketQuality.extra: 'extra',
};

_Stage3FormData _$Stage3FormDataFromJson(Map<String, dynamic> json) =>
    _Stage3FormData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      stage2LoadId: json['stage2LoadId'] as String,
      date: DateTime.parse(json['date'] as String),
      baskets: (json['baskets'] as List<dynamic>)
          .map((e) => BasketWeighData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Stage3FormDataToJson(_Stage3FormData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'stage2LoadId': instance.stage2LoadId,
      'date': instance.date.toIso8601String(),
      'baskets': instance.baskets,
    };
