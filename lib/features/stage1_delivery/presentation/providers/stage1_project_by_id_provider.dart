import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/index.dart';

final stage1ProjectByIdProvider = Provider.family<Stage1FormData?, String>((
  ref,
  id,
) {
  return ref
      .watch(syncStage1ProjectsProvider)
      .firstWhereOrNull((p) => p.id == id);
});
