// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage4Ui)
final stage4UiProvider = Stage4UiFamily._();

final class Stage4UiProvider
    extends $NotifierProvider<Stage4Ui, Stage4UiState> {
  Stage4UiProvider._({
    required Stage4UiFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage4UiProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage4UiHash();

  @override
  String toString() {
    return r'stage4UiProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Stage4Ui create() => Stage4Ui();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Stage4UiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Stage4UiState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage4UiProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage4UiHash() => r'77fa42a55bbce52b5756563d50ffb98e92aafc29';

final class Stage4UiFamily extends $Family
    with
        $ClassFamilyOverride<
          Stage4Ui,
          Stage4UiState,
          Stage4UiState,
          Stage4UiState,
          String
        > {
  Stage4UiFamily._()
    : super(
        retry: null,
        name: r'stage4UiProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage4UiProvider call(String projectId) =>
      Stage4UiProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage4UiProvider';
}

abstract class _$Stage4Ui extends $Notifier<Stage4UiState> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  Stage4UiState build(String projectId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Stage4UiState, Stage4UiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Stage4UiState, Stage4UiState>,
              Stage4UiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
