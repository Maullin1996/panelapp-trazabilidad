// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage1_form_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage1FormData _$Stage1FormDataFromJson(Map<String, dynamic> json) =>
    _Stage1FormData(
      id: json['id'] as String,
      name: json['name'] as String,
      gaveras: (json['gaveras'] as List<dynamic>)
          .map((e) => GaveraData.fromJson(e as Map<String, dynamic>))
          .toList(),
      basketsQuantity: (json['basketsQuantity'] as num).toInt(),
      preservativesWeight: (json['preservativesWeight'] as num).toDouble(),
      preservativesJars: (json['preservativesJars'] as num).toInt(),
      limeWeight: (json['limeWeight'] as num).toDouble(),
      limeJars: (json['limeJars'] as num).toInt(),
      phone: json['phone'] as String,
      date: DateTime.parse(json['date'] as String),
      photoPath: json['photoPath'] as String?,
    );

Map<String, dynamic> _$Stage1FormDataToJson(_Stage1FormData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gaveras': instance.gaveras,
      'basketsQuantity': instance.basketsQuantity,
      'preservativesWeight': instance.preservativesWeight,
      'preservativesJars': instance.preservativesJars,
      'limeWeight': instance.limeWeight,
      'limeJars': instance.limeJars,
      'phone': instance.phone,
      'date': instance.date.toIso8601String(),
      'photoPath': instance.photoPath,
    };

_GaveraData _$GaveraDataFromJson(Map<String, dynamic> json) => _GaveraData(
  quantity: (json['quantity'] as num?)?.toInt() ?? 0,
  referenceWeight: (json['referenceWeight'] as num).toDouble(),
);

Map<String, dynamic> _$GaveraDataToJson(_GaveraData instance) =>
    <String, dynamic>{
      'quantity': instance.quantity,
      'referenceWeight': instance.referenceWeight,
    };
