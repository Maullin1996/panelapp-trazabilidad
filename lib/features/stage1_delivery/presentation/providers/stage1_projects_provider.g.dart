// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage1_projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage1Projects)
final stage1ProjectsProvider = Stage1ProjectsProvider._();

final class Stage1ProjectsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stage1FormData>>,
          List<Stage1FormData>,
          Stream<List<Stage1FormData>>
        >
    with
        $FutureModifier<List<Stage1FormData>>,
        $StreamProvider<List<Stage1FormData>> {
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
  $StreamProviderElement<List<Stage1FormData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Stage1FormData>> create(Ref ref) {
    return stage1Projects(ref);
  }
}

String _$stage1ProjectsHash() => r'6ebe3be03ae851a802e97f6e32c90259de1a2fcd';
