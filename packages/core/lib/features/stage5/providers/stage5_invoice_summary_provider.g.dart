// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_invoice_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage5InvoiceSummary)
final stage5InvoiceSummaryProvider = Stage5InvoiceSummaryFamily._();

final class Stage5InvoiceSummaryProvider
    extends
        $FunctionalProvider<
          InvoiceQualitySummary,
          InvoiceQualitySummary,
          InvoiceQualitySummary
        >
    with $Provider<InvoiceQualitySummary> {
  Stage5InvoiceSummaryProvider._({
    required Stage5InvoiceSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage5InvoiceSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage5InvoiceSummaryHash();

  @override
  String toString() {
    return r'stage5InvoiceSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<InvoiceQualitySummary> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InvoiceQualitySummary create(Ref ref) {
    final argument = this.argument as String;
    return stage5InvoiceSummary(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InvoiceQualitySummary value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InvoiceQualitySummary>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5InvoiceSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage5InvoiceSummaryHash() =>
    r'e6d0cbf098ebdcd2d4f59d6aa733a5e713d999fa';

final class Stage5InvoiceSummaryFamily extends $Family
    with $FunctionalFamilyOverride<InvoiceQualitySummary, String> {
  Stage5InvoiceSummaryFamily._()
    : super(
        retry: null,
        name: r'stage5InvoiceSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage5InvoiceSummaryProvider call(String projectId) =>
      Stage5InvoiceSummaryProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage5InvoiceSummaryProvider';
}
