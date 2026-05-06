// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage4FormData _$Stage4FormDataFromJson(Map<String, dynamic> json) =>
    _Stage4FormData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      returnedGaveras: (json['returnedGaveras'] as List<dynamic>)
          .map((e) => ReturnedGaveras.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnedBaskets: (json['returnedBaskets'] as num).toInt(),
      returnedPreservativesJars: (json['returnedPreservativesJars'] as num)
          .toInt(),
      returnedLimeJars: (json['returnedLimeJars'] as num).toInt(),
    );

Map<String, dynamic> _$Stage4FormDataToJson(_Stage4FormData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'date': instance.date.toIso8601String(),
      'returnedGaveras': instance.returnedGaveras,
      'returnedBaskets': instance.returnedBaskets,
      'returnedPreservativesJars': instance.returnedPreservativesJars,
      'returnedLimeJars': instance.returnedLimeJars,
    };

_ReturnedGaveras _$ReturnedGaverasFromJson(Map<String, dynamic> json) =>
    _ReturnedGaveras(
      quantity: (json['quantity'] as num).toInt(),
      referenceWeight: (json['referenceWeight'] as num).toDouble(),
    );

Map<String, dynamic> _$ReturnedGaverasToJson(_ReturnedGaveras instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'referenceWeight': instance.referenceWeight,
    };
