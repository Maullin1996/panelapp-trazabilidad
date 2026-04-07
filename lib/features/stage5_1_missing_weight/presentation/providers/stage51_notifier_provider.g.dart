// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage51_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stage51Notifier)
final stage51Provider = Stage51NotifierProvider._();

final class Stage51NotifierProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PaymentData>>,
          List<PaymentData>,
          Stream<List<PaymentData>>
        >
    with
        $FutureModifier<List<PaymentData>>,
        $StreamProvider<List<PaymentData>> {
  Stage51NotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage51Provider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage51NotifierHash();

  @$internal
  @override
  $StreamProviderElement<List<PaymentData>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<PaymentData>> create(Ref ref) {
    return stage51Notifier(ref);
  }
}

String _$stage51NotifierHash() => r'ea8ed83114dd635da88bc7f326ccabef143d5c00';
