import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../stage1_delivery/domain/entities/stage1_form_data.dart';

part 'stage4_form_data.freezed.dart';
part 'stage4_form_data.g.dart';

@freezed
abstract class Stage4FormData with _$Stage4FormData {
  const factory Stage4FormData({
    required String id,
    required String projectId,
    required DateTime date,
    required List<ReturnedGaveras> returnedGaveras,
    required List<ReturnedBaskets> returnedBaskets,
    required int returnedPreservativesJars,
    required int returnedLimeJars,
  }) = _Stage4FormData;

  factory Stage4FormData.fromJson(Map<String, dynamic> json) =>
      _$Stage4FormDataFromJson(json);
}

@freezed
abstract class ReturnedBaskets with _$ReturnedBaskets {
  const factory ReturnedBaskets({
    required BasketSize size,
    required int quantity,
  }) = _ReturnedBaskets;

  factory ReturnedBaskets.fromJson(Map<String, dynamic> json) =>
      _$ReturnedBasketsFromJson(json);
}

@freezed
abstract class ReturnedGaveras with _$ReturnedGaveras {
  const factory ReturnedGaveras({
    required int quantity,
    required double referenceWeight,
  }) = _ReturnedGaveras;

  factory ReturnedGaveras.fromJson(Map<String, dynamic> json) =>
      _$ReturnedGaverasFromJson(json);
}
