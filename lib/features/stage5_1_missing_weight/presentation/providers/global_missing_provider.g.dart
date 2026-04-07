// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_missing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage3GlobalSummary)
final stage3GlobalSummaryProvider = Stage3GlobalSummaryFamily._();

final class Stage3GlobalSummaryProvider
    extends
        $FunctionalProvider<
          Stage3GlobalSummary,
          Stage3GlobalSummary,
          Stage3GlobalSummary
        >
    with $Provider<Stage3GlobalSummary> {
  Stage3GlobalSummaryProvider._({
    required Stage3GlobalSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage3GlobalSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage3GlobalSummaryHash();

  @override
  String toString() {
    return r'stage3GlobalSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Stage3GlobalSummary> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Stage3GlobalSummary create(Ref ref) {
    final argument = this.argument as String;
    return stage3GlobalSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage3GlobalSummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage3GlobalSummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage3GlobalSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage3GlobalSummaryHash() =>
    r'948ef8064198e03506607a0bf89958074e15e47a';

final class Stage3GlobalSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stage3GlobalSummary, String> {
  Stage3GlobalSummaryFamily._()
    : super(
        retry: null,
        name: r'stage3GlobalSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage3GlobalSummaryProvider call(String projectId) =>
      Stage3GlobalSummaryProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage3GlobalSummaryProvider';
}
