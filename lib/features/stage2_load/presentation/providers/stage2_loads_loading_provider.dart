import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stage2_load_provider.dart';

final stage2ProjectsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage2LoadProvider).isLoading;
});
