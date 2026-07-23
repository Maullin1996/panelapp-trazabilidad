// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'molienda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Molienda _$MoliendaFromJson(Map<String, dynamic> json) => _Molienda(
  id: json['id'] as String,
  nombre: json['nombre'] as String,
  telefono: json['telefono'] as String,
  creadoEn: DateTime.parse(json['creadoEn'] as String),
);

Map<String, dynamic> _$MoliendaToJson(_Molienda instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'telefono': instance.telefono,
  'creadoEn': instance.creadoEn.toIso8601String(),
};
