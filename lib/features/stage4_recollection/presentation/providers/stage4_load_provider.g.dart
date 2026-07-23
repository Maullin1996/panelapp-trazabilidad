// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_load_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage4Load)
final stage4LoadProvider = Stage4LoadFamily._();

final class Stage4LoadProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Stage4FormData>>,
          List<Stage4FormData>,
          Stream<List<Stage4FormData>>
        >
    with
        $FutureModifier<List<Stage4FormData>>,
        $StreamProvider<List<Stage4FormData>> {
  Stage4LoadProvider._({
    required Stage4LoadFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage4LoadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage4LoadHash();

  @override
  String toString() {
    return r'stage4LoadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Stage4FormData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Stage4FormData>> create(Ref ref) {
    final argument = this.argument as String;
    return stage4Load(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage4LoadProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage4LoadHash() => r'4d0850626b7022c72fcdddb2fd9cd9e77ed18a29';

final class Stage4LoadFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Stage4FormData>>, String> {
  Stage4LoadFamily._()
    : super(
        retry: null,
        name: r'stage4LoadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage4LoadProvider call(String projectId) =>
      Stage4LoadProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage4LoadProvider';
}
