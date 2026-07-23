// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage3_load_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage3Load)
final stage3LoadProvider = Stage3LoadProvider._();

final class Stage3LoadProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stage3FormData>>,
          List<Stage3FormData>,
          Stream<List<Stage3FormData>>
        >
    with
        $FutureModifier<List<Stage3FormData>>,
        $StreamProvider<List<Stage3FormData>> {
  Stage3LoadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage3LoadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage3LoadHash();

  @$internal
  @override
  $StreamProviderElement<List<Stage3FormData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Stage3FormData>> create(Ref ref) {
    return stage3Load(ref);
  }
}

String _$stage3LoadHash() => r'90fb49725c335bd1553d9a6066111d4c1ec2fda3';
