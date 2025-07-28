import 'package:registro_panela/features/stage3_weigh/data/mock_stage3_entries.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage3_load_provider.g.dart';

@riverpod
class Stage3Load extends _$Stage3Load {
  @override
  List<Stage3FormData> build() => mockStage3Entries;

  void add(Stage3FormData entry) {
    state = [entry, ...state];
  }

  void update(Stage3FormData entry) {
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
  }
}
