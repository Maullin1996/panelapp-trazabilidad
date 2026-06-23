import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/molienda.dart';

class MoliendaModel {
  final String id;
  final String nombre;
  final String telefono;
  final DateTime creadoEn;

  const MoliendaModel({
    required this.id,
    required this.nombre,
    required this.telefono,
    required this.creadoEn,
  });

  factory MoliendaModel.fromJson(Map<String, dynamic> json) => MoliendaModel(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        telefono: json['telefono'] as String,
        creadoEn: (json['creadoEn'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'telefono': telefono,
        'creadoEn': Timestamp.fromDate(creadoEn),
      };

  factory MoliendaModel.fromEntity(Molienda entity) => MoliendaModel(
        id: entity.id,
        nombre: entity.nombre,
        telefono: entity.telefono,
        creadoEn: entity.creadoEn,
      );

  Molienda toEntity() => Molienda(
        id: id,
        nombre: nombre,
        telefono: telefono,
        creadoEn: creadoEn,
      );
}
