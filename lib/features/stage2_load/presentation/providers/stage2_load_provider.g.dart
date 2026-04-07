// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage2_load_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage2Load)
final stage2LoadProvider = Stage2LoadProvider._();

final class Stage2LoadProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stage2LoadData>>,
          List<Stage2LoadData>,
          Stream<List<Stage2LoadData>>
        >
    with
        $FutureModifier<List<Stage2LoadData>>,
        $StreamProvider<List<Stage2LoadData>> {
  Stage2LoadProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage2LoadProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage2LoadHash();

  @$internal
  @override
  $StreamProviderElement<List<Stage2LoadData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Stage2LoadData>> create(Ref ref) {
    return stage2Load(ref);
  }
}

String _$stage2LoadHash() => r'992fe0e59693eb7931f5c3c723754b5c39cef594';
