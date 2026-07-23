// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage52_load_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage52Load)
final stage52LoadProvider = Stage52LoadProvider._();

final class Stage52LoadProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stage52RecordData>>,
          List<Stage52RecordData>,
          Stream<List<Stage52RecordData>>
        >
    with
        $FutureModifier<List<Stage52RecordData>>,
        $StreamProvider<List<Stage52RecordData>> {
  Stage52LoadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage52LoadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage52LoadHash();

  @$internal
  @override
  $StreamProviderElement<List<Stage52RecordData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Stage52RecordData>> create(Ref ref) {
    return stage52Load(ref);
  }
}

String _$stage52LoadHash() => r'c88470913364c0e14eb5f110e8619a9bbb790e7c';
