import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';
import 'package:registro_panela/features/stage1_delivery/providers/stage1_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage1_projects_provider.g.dart';

@riverpod
class Stage1Projects extends _$Stage1Projects {
  @override
  Future<List<Stage1FormData>> build() async {
    final usecase = ref.read(getStage1ProjectsProvider);
    return usecase();
  }

  void loadFromBackend(List<Stage1FormData> projectsFromApi) {
    state = AsyncData(projectsFromApi);
  }

  void addProjectOptimistic(Stage1FormData project) {
    state.whenData((projects) {
      state = AsyncData([project, ...projects]);
    });
  }

  void updateProjectOptimistic(Stage1FormData updatedProject) {
    state.whenData((projects) {
      final updatedList = projects
          .map((p) => p.id == updatedProject.id ? updatedProject : p)
          .toList();
      state = AsyncData(updatedList);
    });
  }

  void removeProjectOptimistic(String id) {
    state.whenData((projects) {
      final filteredList = projects.where((p) => p.id != id).toList();
      state = AsyncData(filteredList);
    });
  }

  void refresh() {
    ref.invalidateSelf();
  }
}
