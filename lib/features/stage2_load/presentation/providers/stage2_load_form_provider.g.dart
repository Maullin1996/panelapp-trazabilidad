// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage2_load_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage2Form)
final stage2FormProvider = Stage2FormProvider._();

final class Stage2FormProvider
    extends $NotifierProvider<Stage2Form, Stage2FormState> {
  Stage2FormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage2FormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage2FormHash();

  @$internal
  @override
  Stage2Form create() => Stage2Form();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage2FormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage2FormState>(value),
    );
  }
}

String _$stage2FormHash() => r'4c67e24886351f9b09a73164a2a590490ca6fbf7';

abstract class _$Stage2Form extends $Notifier<Stage2FormState> {
  Stage2FormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage2FormState, Stage2FormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage2FormState, Stage2FormState>,
              Stage2FormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
