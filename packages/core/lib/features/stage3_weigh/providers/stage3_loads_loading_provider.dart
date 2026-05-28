import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stage3_load_provider.dart';

final stage3LoadsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage3LoadProvider).isLoading;
});
