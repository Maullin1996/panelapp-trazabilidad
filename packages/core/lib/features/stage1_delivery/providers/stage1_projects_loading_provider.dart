import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'stage1_projects_provider.dart';

final stage1ProjectsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(stage1ProjectsProvider).isLoading;
});
