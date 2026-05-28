// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage52_form_status.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage52Form)
final stage52FormProvider = Stage52FormProvider._();

final class Stage52FormProvider
    extends $NotifierProvider<Stage52Form, Stage52FormState> {
  Stage52FormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stage52FormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stage52FormHash();

  @$internal
  @override
  Stage52Form create() => Stage52Form();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage52FormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage52FormState>(value),
    );
  }
}

String _$stage52FormHash() => r'e5a4f4dc7316ec2d347271e95168937116927a9a';

abstract class _$Stage52Form extends $Notifier<Stage52FormState> {
  Stage52FormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage52FormState, Stage52FormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage52FormState, Stage52FormState>,
              Stage52FormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
