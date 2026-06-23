import 'package:freezed_annotation/freezed_annotation.dart';

part 'entrega.freezed.dart';
part 'entrega.g.dart';

@freezed
abstract class Entrega with _$Entrega {
  const factory Entrega({
    required String id,
    required String moliendaId,
    required String produccionId,   // referencia al Stage1FormData.id
    required DateTime fechaEntrega,
    required String qrToken,        // UUID único para el QR
  }) = _Entrega;

  factory Entrega.fromJson(Map<String, dynamic> json) =>
      _$EntregaFromJson(json);
}
