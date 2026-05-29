import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/features/stage3_weigh/domain/entities/basket_quality.dart';
part 'stage52_record_data.freezed.dart';
part 'stage52_record_data.g.dart';

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
