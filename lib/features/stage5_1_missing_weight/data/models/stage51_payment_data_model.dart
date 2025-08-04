import 'package:registro_panela/features/stage5_1_missing_weight/domain/entities/payment_data.dart';

/// Modelo de datos para persistencia de PaymentData
class PaymentDataModel {
  final String id;
  final String projectId;
  final String date; // ISO String para JSON
  final double amount;

  PaymentDataModel({
    required this.id,
    required this.projectId,
    required this.date,
    required this.amount,
  });

  /// Convierte de la entidad de dominio a este modelo
  factory PaymentDataModel.fromEntity(PaymentData data) {
    return PaymentDataModel(
      id: data.id,
      projectId: data.projectId,
      date: data.date.toIso8601String(),
      amount: data.amount,
    );
  }

  /// Convierte de este modelo a la entidad de dominio
  PaymentData toEntity() {
    return PaymentData(
      id: id,
      projectId: projectId,
      date: DateTime.parse(date),
      amount: amount,
    );
  }

  /// Serializa a JSON para almacenamiento en Firebase u otro backend
  Map<String, dynamic> toJson() {
    return {'id': id, 'projectId': projectId, 'date': date, 'amount': amount};
  }

  /// Crea este modelo desde JSON
  factory PaymentDataModel.fromJson(Map<String, dynamic> json) {
    return PaymentDataModel(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
