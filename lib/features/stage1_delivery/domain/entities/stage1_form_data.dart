import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage1_form_data.freezed.dart';
part 'stage1_form_data.g.dart';

@freezed
abstract class Stage1FormData with _$Stage1FormData {
  const factory Stage1FormData({
    required String id,
    required String name,
    required List<GaveraData> gaveras,
    required int basketsQuantity,
    required double preservativesWeight,
    required int preservativesJars,
    required double limeWeight,
    required int limeJars,
    required String phone,
    required DateTime date,
    String? photoPath,
  }) = _Stage1FormData;

  factory Stage1FormData.fromJson(Map<String, dynamic> json) =>
      _$Stage1FormDataFromJson(json);
}

@freezed
abstract class GaveraData with _$GaveraData {
  const factory GaveraData({
    @Default(0) int quantity,
    required double referenceWeight,
  }) = _GaveraData;

  factory GaveraData.fromJson(Map<String, dynamic> json) =>
      _$GaveraDataFromJson(json);
}
