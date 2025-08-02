import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';

part 'stage4_ui_state.freezed.dart';

@freezed
abstract class Stage4UiState with _$Stage4UiState {
  const factory Stage4UiState({
    required List<ReturnedGaveras> returnedGaveras,
    required int returnedBaskets,
    required int returnedPreservativesJars,
    required int returnedLimeJars,
  }) = _Stage4UiState;
}
