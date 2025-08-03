import 'package:freezed_annotation/freezed_annotation.dart';

part 'stage52_record_data.freezed.dart';
part 'stage52_record_data.g.dart';

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
abstract class Stage52RecordData with _$Stage52RecordData {
  const factory Stage52RecordData({
    required String id,
    required String projectId,
    required double gaveraWeight, // de Stage1
    required double panelaWeight, // peso real de panela
    required int unitCount, // unidades de panela (ej. número de sacos)
    required BasketQuality quality, // reuseamos el enum de Stage3
    required String photoPath,
    required DateTime date,
  }) = _Stage52RecordData;

  factory Stage52RecordData.fromJson(Map<String, dynamic> json) =>
      _$Stage52RecordDataFromJson(json);
}
