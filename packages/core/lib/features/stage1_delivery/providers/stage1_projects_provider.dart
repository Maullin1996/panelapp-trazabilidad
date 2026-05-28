import '../domain/entities/stage1_form_data.dart';
import 'stage1_usecases_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stage1_projects_provider.g.dart';

@riverpod
class Stage1Projects extends _$Stage1Projects {
  static const int _pageSize = 10;
  int _currentLimit = _pageSize;
  bool _isLoadingMore = false;

  @override
  Stream<List<Stage1FormData>> build() {
    return _watchWithLimit();
  }

  Stream<List<Stage1FormData>> _watchWithLimit() {
    final usecase = ref.watch(watchStage1ProjectsProvider);
    return usecase(limit: _currentLimit).map((projects) {
      _isLoadingMore = false;
      return projects;
    });
  }

  void loadMore() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    _currentLimit += _pageSize;
    ref.invalidateSelf();
  }

  bool canLoadMore(List<Stage1FormData> projects) {
    return !_isLoadingMore && projects.length == _currentLimit;
  }
}

// @riverpod
// Stream<List<Stage1FormData>> stage1Projects(Ref ref) {
//   final usecase = ref.watch(watchStage1ProjectsProvider);
//   return usecase();
// }
