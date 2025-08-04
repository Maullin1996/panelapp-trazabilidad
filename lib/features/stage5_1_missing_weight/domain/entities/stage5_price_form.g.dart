// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_price_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Stage5PriceFormData _$Stage5PriceFormDataFromJson(Map<String, dynamic> json) =>
    _Stage5PriceFormData(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: DateTime.parse(json['date'] as String),
      pricePerKilo: (json['pricePerKilo'] as num?)?.toDouble() ?? 0,
      installment: (json['installment'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$Stage5PriceFormDataToJson(
  _Stage5PriceFormData instance,
) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'date': instance.date.toIso8601String(),
  'pricePerKilo': instance.pricePerKilo,
  'installment': instance.installment,
};
