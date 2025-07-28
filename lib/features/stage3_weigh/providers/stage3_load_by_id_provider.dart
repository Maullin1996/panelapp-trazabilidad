import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage3_weigh/domain/entities/stage3_form_data.dart';
import 'package:registro_panela/features/stage3_weigh/providers/stage3_load_provider.dart';

final stage3LoadsByIdProvider = Provider.family<Stage3FormData?, String>((
  ref,
  id,
) {
  final asyncWeights = ref.watch(stage3LoadProvider);

  return asyncWeights.maybeWhen(
    data: (data) => data.firstWhereOrNull((p) => p.id == id),
    orElse: () => null,
  );
});
