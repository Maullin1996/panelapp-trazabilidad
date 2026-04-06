import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/presentation/providers/stage1_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage1_projects_provider.g.dart';

@riverpod
Stream<List<Stage1FormData>> stage1Projects(Ref ref) {
  final usecase = ref.read(watchStage1ProjectsProvider);
  return usecase();
}
