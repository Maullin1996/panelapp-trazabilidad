import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_data.freezed.dart';
part 'payment_data.g.dart';

@freezed
abstract class PaymentData with _$PaymentData {
  const factory PaymentData({
    required String id,
    required String projectId,
    required DateTime date,
    required double amount,
  }) = _PaymentData;

  factory PaymentData.fromJson(Map<String, dynamic> json) =>
      _$PaymentDataFromJson(json);
}
