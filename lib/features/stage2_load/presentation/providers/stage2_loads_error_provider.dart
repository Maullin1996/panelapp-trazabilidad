import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stage2_load_provider.dart';

final stage2LoadsErrorProvider = Provider<String?>((ref) {
  final asyncProjects = ref.watch(stage2LoadProvider);
  return asyncProjects.maybeWhen(
    error: (error, _) => error.toString(),
    orElse: () => null,
  );
});
