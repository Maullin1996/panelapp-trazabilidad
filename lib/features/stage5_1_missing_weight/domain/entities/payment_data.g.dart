// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentData _$PaymentDataFromJson(Map<String, dynamic> json) => _PaymentData(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  date: DateTime.parse(json['date'] as String),
  amount: (json['amount'] as num).toDouble(),
);

Map<String, dynamic> _$PaymentDataToJson(_PaymentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'date': instance.date.toIso8601String(),
      'amount': instance.amount,
    };
