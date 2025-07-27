// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage2_load_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage2LoadData _$Stage2LoadDataFromJson(Map<String, dynamic> json) =>
    _Stage2LoadData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      baskets: BasketLoadData.fromJson(json['baskets'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Stage2LoadDataToJson(_Stage2LoadData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'date': instance.date.toIso8601String(),
      'baskets': instance.baskets,
    };

_BasketLoadData _$BasketLoadDataFromJson(Map<String, dynamic> json) =>
    _BasketLoadData(
      referenceWeight: (json['referenceWeight'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      realWeight: (json['realWeight'] as num).toDouble(),
    );

Map<String, dynamic> _$BasketLoadDataToJson(_BasketLoadData instance) =>
    <String, dynamic>{
      'referenceWeight': instance.referenceWeight,
      'count': instance.count,
      'realWeight': instance.realWeight,
    };
