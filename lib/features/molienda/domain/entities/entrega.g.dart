// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entrega.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entrega _$EntregaFromJson(Map<String, dynamic> json) => _Entrega(
  id: json['id'] as String,
  moliendaId: json['moliendaId'] as String,
  produccionId: json['produccionId'] as String,
  fechaEntrega: DateTime.parse(json['fechaEntrega'] as String),
  qrToken: json['qrToken'] as String,
);

Map<String, dynamic> _$EntregaToJson(_Entrega instance) => <String, dynamic>{
  'id': instance.id,
  'moliendaId': instance.moliendaId,
  'produccionId': instance.produccionId,
  'fechaEntrega': instance.fechaEntrega.toIso8601String(),
  'qrToken': instance.qrToken,
};
