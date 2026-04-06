import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_projects_provider.dart';

final stage1ProjectsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage1ProjectsProvider).isLoading;
});
