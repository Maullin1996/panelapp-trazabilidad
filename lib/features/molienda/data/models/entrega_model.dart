import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/entrega.dart';

class EntregaModel {
  final String id;
  final String moliendaId;
  final String produccionId;
  final DateTime fechaEntrega;
  final String qrToken;

  const EntregaModel({
    required this.id,
    required this.moliendaId,
    required this.produccionId,
    required this.fechaEntrega,
    required this.qrToken,
  });

  factory EntregaModel.fromJson(Map<String, dynamic> json) => EntregaModel(
        id: json['id'] as String,
        moliendaId: json['moliendaId'] as String,
        produccionId: json['produccionId'] as String,
        fechaEntrega: (json['fechaEntrega'] as Timestamp).toDate(),
        qrToken: json['qrToken'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'moliendaId': moliendaId,
        'produccionId': produccionId,
        'fechaEntrega': Timestamp.fromDate(fechaEntrega),
        'qrToken': qrToken,
      };

  factory EntregaModel.fromEntity(Entrega entity) => EntregaModel(
        id: entity.id,
        moliendaId: entity.moliendaId,
        produccionId: entity.produccionId,
        fechaEntrega: entity.fechaEntrega,
        qrToken: entity.qrToken,
      );

  Entrega toEntity() => Entrega(
        id: id,
        moliendaId: moliendaId,
        produccionId: produccionId,
        fechaEntrega: fechaEntrega,
        qrToken: qrToken,
      );
}
