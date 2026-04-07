// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage5Summary)
final stage5SummaryProvider = Stage5SummaryFamily._();

final class Stage5SummaryProvider
    extends
        $FunctionalProvider<
          List<Stage5SummaryDay>,
          List<Stage5SummaryDay>,
          List<Stage5SummaryDay>
        >
    with $Provider<List<Stage5SummaryDay>> {
  Stage5SummaryProvider._({
    required Stage5SummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage5SummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage5SummaryHash();

  @override
  String toString() {
    return r'stage5SummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Stage5SummaryDay>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<Stage5SummaryDay> create(Ref ref) {
    final argument = this.argument as String;
    return stage5Summary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Stage5SummaryDay> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Stage5SummaryDay>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5SummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage5SummaryHash() => r'3d8e6eef79d2aebf3ba3f2403a698ae8be14a87a';

final class Stage5SummaryFamily extends $Family
    with $FunctionalFamilyOverride<List<Stage5SummaryDay>, String> {
  Stage5SummaryFamily._()
    : super(
        retry: null,
        name: r'stage5SummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage5SummaryProvider call(String projectId) =>
      Stage5SummaryProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage5SummaryProvider';
}
