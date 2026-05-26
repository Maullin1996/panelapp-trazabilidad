import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_panela/features/stage5_2_records/domain/entities/stage52_record_data.dart';

part 'stage2_load_data.freezed.dart';
part 'stage2_load_data.g.dart';

@freezed
abstract class Stage2LoadData with _$Stage2LoadData {
  const factory Stage2LoadData({
    required String id,
    required String projectId,
    required DateTime date,
    required BasketLoadData baskets,
  }) = _Stage2LoadData;

  factory Stage2LoadData.fromJson(Map<String, dynamic> json) =>
      _$Stage2LoadDataFromJson(json);
}

@freezed
abstract class BasketLoadData with _$BasketLoadData {
  const factory BasketLoadData({
    required double referenceWeight,
    required int count,
    required BasketQuality quality,
  }) = _BasketLoadData;

  factory BasketLoadData.fromJson(Map<String, dynamic> json) =>
      _$BasketLoadDataFromJson(json);
}
