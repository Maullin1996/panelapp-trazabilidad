import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage2_load/providers/stage2_load_provider.dart';

final stage1ProjectsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage2LoadProvider).isLoading;
});
