// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_global_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage5GlobalSummary)
final stage5GlobalSummaryProvider = Stage5GlobalSummaryFamily._();

final class Stage5GlobalSummaryProvider
    extends
        $FunctionalProvider<
          List<Stage5SummaryItem>,
          List<Stage5SummaryItem>,
          List<Stage5SummaryItem>
        >
    with $Provider<List<Stage5SummaryItem>> {
  Stage5GlobalSummaryProvider._({
    required Stage5GlobalSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage5GlobalSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage5GlobalSummaryHash();

  @override
  String toString() {
    return r'stage5GlobalSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Stage5SummaryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Stage5SummaryItem> create(Ref ref) {
    final argument = this.argument as String;
    return stage5GlobalSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Stage5SummaryItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Stage5SummaryItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5GlobalSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage5GlobalSummaryHash() =>
    r'620a5d9c6da91a312b9e2868f2d117b8e751fc87';

final class Stage5GlobalSummaryFamily extends $Family
    with $FunctionalFamilyOverride<List<Stage5SummaryItem>, String> {
  Stage5GlobalSummaryFamily._()
    : super(
        retry: null,
        name: r'stage5GlobalSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage5GlobalSummaryProvider call(String projectId) =>
      Stage5GlobalSummaryProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage5GlobalSummaryProvider';
}
