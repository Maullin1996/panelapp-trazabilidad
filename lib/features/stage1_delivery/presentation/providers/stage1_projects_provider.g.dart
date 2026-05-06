// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage1_projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage1Projects)
final stage1ProjectsProvider = Stage1ProjectsProvider._();

final class Stage1ProjectsProvider
    extends $StreamNotifierProvider<Stage1Projects, List<Stage1FormData>> {
  Stage1ProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage1ProjectsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage1ProjectsHash();

  @$internal
  @override
  Stage1Projects create() => Stage1Projects();
}

String _$stage1ProjectsHash() => r'2be9d6583dabb208611e0e7524746683088e9384';

abstract class _$Stage1Projects extends $StreamNotifier<List<Stage1FormData>> {
  Stream<List<Stage1FormData>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<Stage1FormData>>, List<Stage1FormData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Stage1FormData>>,
                List<Stage1FormData>
              >,
              AsyncValue<List<Stage1FormData>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
