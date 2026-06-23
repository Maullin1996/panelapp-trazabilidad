import 'package:freezed_annotation/freezed_annotation.dart';

part 'molienda.freezed.dart';
part 'molienda.g.dart';

@freezed
abstract class Molienda with _$Molienda {
  const factory Molienda({
    required String id,
    required String nombre,
    required String telefono,
    required DateTime creadoEn,
  }) = _Molienda;

  factory Molienda.fromJson(Map<String, dynamic> json) =>
      _$MoliendaFromJson(json);
}
