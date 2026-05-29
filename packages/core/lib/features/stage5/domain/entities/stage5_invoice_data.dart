// stage5_invoice_data.dart
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage5_invoice_data.freezed.dart';
part 'stage5_invoice_data.g.dart';

@freezed
abstract class Stage5InvoiceData with _$Stage5InvoiceData {
  const factory Stage5InvoiceData({
    required String id,
    required String projectId,
    required DateTime date,
    required List<InvoiceQualityLine> lines, // una línea por calidad
  }) = _Stage5InvoiceData;

  factory Stage5InvoiceData.fromJson(Map<String, dynamic> json) =>
      _$Stage5InvoiceDataFromJson(json);
}

@freezed
abstract class InvoiceQualityLine with _$InvoiceQualityLine {
  const factory InvoiceQualityLine({
    required BasketQuality quality,
    required int totalKg,
    required double bultos,
    required double pricePerBulto,
    required double subtotal,
  }) = _InvoiceQualityLine;

  factory InvoiceQualityLine.fromJson(Map<String, dynamic> json) =>
      _$InvoiceQualityLineFromJson(json);
}
