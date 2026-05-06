// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show_buttom_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ShowButtom)
final showButtomProvider = ShowButtomProvider._();

final class ShowButtomProvider extends $NotifierProvider<ShowButtom, bool> {
  ShowButtomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showButtomProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showButtomHash();

  @$internal
  @override
  ShowButtom create() => ShowButtom();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showButtomHash() => r'8ee0b856767b98e795ae75964414decc50a19988';

abstract class _$ShowButtom extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
