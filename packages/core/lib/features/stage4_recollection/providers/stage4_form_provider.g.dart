// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage4Form)
final stage4FormProvider = Stage4FormProvider._();

final class Stage4FormProvider
    extends $NotifierProvider<Stage4Form, Stage4FormState> {
  Stage4FormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage4FormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage4FormHash();

  @$internal
  @override
  Stage4Form create() => Stage4Form();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage4FormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage4FormState>(value),
    );
  }
}

String _$stage4FormHash() => r'03079ed5a7c5b2b0051d9771dea021c06ddf24f5';

abstract class _$Stage4Form extends $Notifier<Stage4FormState> {
  Stage4FormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage4FormState, Stage4FormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage4FormState, Stage4FormState>,
              Stage4FormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
