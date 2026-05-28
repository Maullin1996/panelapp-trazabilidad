import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/entities/stage2_load_data.dart';
import 'providers.dart';

final stage2LoadsByIdProvider = Provider.family<Stage2LoadData?, String>((
  ref,
  id,
) {
  final asyncProjects = ref.watch(stage2LoadProvider);

  return asyncProjects.maybeWhen(
    data: (data) => data.firstWhereOrNull((p) => p.id == id),
    orElse: () => null,
  );
});
