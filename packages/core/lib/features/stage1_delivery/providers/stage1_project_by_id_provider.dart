import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage1_form_data.dart';
import 'index.dart';

final stage1ProjectByIdProvider = Provider.family<Stage1FormData?, String>((
  ref,
  id,
) {
  return ref
      .watch(syncStage1ProjectsProvider)
      .firstWhereOrNull((p) => p.id == id);
});
