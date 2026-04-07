// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inputs_math_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(loadSummary)
final loadSummaryProvider = LoadSummaryFamily._();

final class LoadSummaryProvider
    extends $FunctionalProvider<LoadSummary, LoadSummary, LoadSummary>
    with $Provider<LoadSummary> {
  LoadSummaryProvider._({
    required LoadSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'loadSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loadSummaryHash();

  @override
  String toString() {
    return r'loadSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<LoadSummary> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LoadSummary create(Ref ref) {
    final argument = this.argument as String;
    return loadSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadSummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LoadSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loadSummaryHash() => r'93427a4af4ba2001f41a0446b2ebf949fd50c377';

final class LoadSummaryFamily extends $Family
    with $FunctionalFamilyOverride<LoadSummary, String> {
  LoadSummaryFamily._()
    : super(
        retry: null,
        name: r'loadSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoadSummaryProvider call(String load2Id) =>
      LoadSummaryProvider._(argument: load2Id, from: this);

  @override
  String toString() => r'loadSummaryProvider';
}
