// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_price_form_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage5PriceForm)
final stage5PriceFormProvider = Stage5PriceFormProvider._();

final class Stage5PriceFormProvider
    extends $NotifierProvider<Stage5PriceForm, Stage5PriceFormState> {
  Stage5PriceFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage5PriceFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage5PriceFormHash();

  @$internal
  @override
  Stage5PriceForm create() => Stage5PriceForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage5PriceFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage5PriceFormState>(value),
    );
  }
}

String _$stage5PriceFormHash() => r'03c87739e342f664ad588c381f577d8d44a2db50';

abstract class _$Stage5PriceForm extends $Notifier<Stage5PriceFormState> {
  Stage5PriceFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage5PriceFormState, Stage5PriceFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage5PriceFormState, Stage5PriceFormState>,
              Stage5PriceFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
