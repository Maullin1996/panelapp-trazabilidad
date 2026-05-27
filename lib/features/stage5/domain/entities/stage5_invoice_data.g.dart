// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_invoice_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage5InvoiceData _$Stage5InvoiceDataFromJson(Map<String, dynamic> json) =>
    _Stage5InvoiceData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      lines: (json['lines'] as List<dynamic>)
          .map((e) => InvoiceQualityLine.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$Stage5InvoiceDataToJson(_Stage5InvoiceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'date': instance.date.toIso8601String(),
      'lines': instance.lines,
    };

_InvoiceQualityLine _$InvoiceQualityLineFromJson(Map<String, dynamic> json) =>
    _InvoiceQualityLine(
      quality: $enumDecode(_$BasketQualityEnumMap, json['quality']),
      totalKg: (json['totalKg'] as num).toInt(),
      bultos: (json['bultos'] as num).toDouble(),
      pricePerBulto: (json['pricePerBulto'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceQualityLineToJson(_InvoiceQualityLine instance) =>
    <String, dynamic>{
      'quality': _$BasketQualityEnumMap[instance.quality]!,
      'totalKg': instance.totalKg,
      'bultos': instance.bultos,
      'pricePerBulto': instance.pricePerBulto,
      'subtotal': instance.subtotal,
    };

const _$BasketQualityEnumMap = {
  BasketQuality.regular: 'regular',
  BasketQuality.buena: 'buena',
  BasketQuality.negra: 'negra',
  BasketQuality.extra: 'extra',
};
