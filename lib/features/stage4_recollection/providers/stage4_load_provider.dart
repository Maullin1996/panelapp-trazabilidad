import 'package:registro_panela/features/stage4_recollection/domin/entities/stage4_form_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage4_load_provider.g.dart';

@riverpod
class Stage4Load extends _$Stage4Load {
  @override
  List<Stage4FormData> build() => [];

  void add(Stage4FormData entry) {
    state = [...state, entry];
  }

  void update(Stage4FormData entry) {
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
  }
}
