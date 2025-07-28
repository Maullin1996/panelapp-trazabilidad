import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage3_form_data.freezed.dart';
part 'stage3_form_data.g.dart';

@JsonEnum(alwaysCreate: true)
enum BasketQuality {
  @JsonValue('regular')
  regular,
  @JsonValue('buena')
  buena,
  @JsonValue('negra')
  negra,
  @JsonValue('extra')
  extra,
}

@freezed
abstract class BasketWeighData with _$BasketWeighData {
  const factory BasketWeighData({
    required String id,
    required int sequence,
    required double referenceWeight,
    required double realWeight,
    required BasketQuality quality,
    required String photoPath,
  }) = _BasketWeighData;

  factory BasketWeighData.fromJson(Map<String, dynamic> json) =>
      _$BasketWeighDataFromJson(json);
}

@freezed
abstract class Stage3FormData with _$Stage3FormData {
  const factory Stage3FormData({
    required String id,
    required String projectId,
    required String stage2LoadId,
    required DateTime date,
    required List<BasketWeighData> baskets,
  }) = _Stage3FormData;

  factory Stage3FormData.fromJson(Map<String, dynamic> json) =>
      _$Stage3FormDataFromJson(json);
}
