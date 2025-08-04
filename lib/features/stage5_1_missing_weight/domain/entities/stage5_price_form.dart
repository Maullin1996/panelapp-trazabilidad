import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage5_price_form.freezed.dart';
part 'stage5_price_form.g.dart';

@freezed
abstract class Stage5PriceFormData with _$Stage5PriceFormData {
  const factory Stage5PriceFormData({
    required String id,
    required String projectId,
    required DateTime date,
    @Default(0) double pricePerKilo,
    @Default(0) double installment,
  }) = _Stage5PriceFormData;

  factory Stage5PriceFormData.fromJson(Map<String, dynamic> json) =>
      _$Stage5PriceFormDataFromJson(json);
}
