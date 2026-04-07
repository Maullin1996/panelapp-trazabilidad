// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage3_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage3Form)
final stage3FormProvider = Stage3FormProvider._();

final class Stage3FormProvider
    extends $NotifierProvider<Stage3Form, Stage3FormState> {
  Stage3FormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage3FormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage3FormHash();

  @$internal
  @override
  Stage3Form create() => Stage3Form();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage3FormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage3FormState>(value),
    );
  }
}

String _$stage3FormHash() => r'f789fb751e01069a058e0c21610817b6483350c6';

abstract class _$Stage3Form extends $Notifier<Stage3FormState> {
  Stage3FormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage3FormState, Stage3FormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage3FormState, Stage3FormState>,
              Stage3FormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
