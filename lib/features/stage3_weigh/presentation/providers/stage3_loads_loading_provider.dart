import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage3_weigh/presentation/providers/stage3_load_provider.dart';

final stage3LoadsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage3LoadProvider).isLoading;
});
