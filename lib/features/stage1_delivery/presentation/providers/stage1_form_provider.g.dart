// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage1_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage1Form)
final stage1FormProvider = Stage1FormProvider._();

final class Stage1FormProvider
    extends $NotifierProvider<Stage1Form, Stage1FormState> {
  Stage1FormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage1FormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage1FormHash();

  @$internal
  @override
  Stage1Form create() => Stage1Form();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage1FormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage1FormState>(value),
    );
  }
}

String _$stage1FormHash() => r'14ecc6af5e7c26a6e95a03178398e52246ee3857';

abstract class _$Stage1Form extends $Notifier<Stage1FormState> {
  Stage1FormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage1FormState, Stage1FormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage1FormState, Stage1FormState>,
              Stage1FormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
