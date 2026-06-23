// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'molienda_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(moliendaDatasource)
final moliendaDatasourceProvider = MoliendaDatasourceProvider._();

final class MoliendaDatasourceProvider
    extends
        $FunctionalProvider<
          MoliendaFirestoreDatasource,
          MoliendaFirestoreDatasource,
          MoliendaFirestoreDatasource
        >
    with $Provider<MoliendaFirestoreDatasource> {
  MoliendaDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moliendaDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moliendaDatasourceHash();

  @$internal
  @override
  $ProviderElement<MoliendaFirestoreDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MoliendaFirestoreDatasource create(Ref ref) {
    return moliendaDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoliendaFirestoreDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoliendaFirestoreDatasource>(value),
    );
  }
}

String _$moliendaDatasourceHash() =>
    r'1e2a22d273a80eb47e4500b457c3c2fac92cbb8b';

@ProviderFor(moliendaRepository)
final moliendaRepositoryProvider = MoliendaRepositoryProvider._();

final class MoliendaRepositoryProvider
    extends
        $FunctionalProvider<
          MoliendaRepository,
          MoliendaRepository,
          MoliendaRepository
        >
    with $Provider<MoliendaRepository> {
  MoliendaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moliendaRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moliendaRepositoryHash();

  @$internal
  @override
  $ProviderElement<MoliendaRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MoliendaRepository create(Ref ref) {
    return moliendaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoliendaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoliendaRepository>(value),
    );
  }
}

String _$moliendaRepositoryHash() =>
    r'3f385393c6135339d800874e7b3cb1949c64b74f';

@ProviderFor(moliendaItems)
final moliendaItemsProvider = MoliendaItemsProvider._();

final class MoliendaItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Molienda>>,
          List<Molienda>,
          Stream<List<Molienda>>
        >
    with $FutureModifier<List<Molienda>>, $StreamProvider<List<Molienda>> {
  MoliendaItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moliendaItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moliendaItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<Molienda>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Molienda>> create(Ref ref) {
    return moliendaItems(ref);
  }
}

String _$moliendaItemsHash() => r'011bf4f2a1e11e9f1ed936c590a6f0ef165ba2f7';

@ProviderFor(syncMoliendaItems)
final syncMoliendaItemsProvider = SyncMoliendaItemsProvider._();

final class SyncMoliendaItemsProvider
    extends $FunctionalProvider<List<Molienda>, List<Molienda>, List<Molienda>>
    with $Provider<List<Molienda>> {
  SyncMoliendaItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncMoliendaItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncMoliendaItemsHash();

  @$internal
  @override
  $ProviderElement<List<Molienda>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Molienda> create(Ref ref) {
    return syncMoliendaItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Molienda> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Molienda>>(value),
    );
  }
}

String _$syncMoliendaItemsHash() => r'2d2231abcd823c1117a477012d0fd67bea01b892';

@ProviderFor(moliendaEntregas)
final moliendaEntregasProvider = MoliendaEntregasFamily._();

final class MoliendaEntregasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Entrega>>,
          List<Entrega>,
          Stream<List<Entrega>>
        >
    with $FutureModifier<List<Entrega>>, $StreamProvider<List<Entrega>> {
  MoliendaEntregasProvider._({
    required MoliendaEntregasFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'moliendaEntregasProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$moliendaEntregasHash();

  @override
  String toString() {
    return r'moliendaEntregasProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Entrega>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Entrega>> create(Ref ref) {
    final argument = this.argument as String;
    return moliendaEntregas(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MoliendaEntregasProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$moliendaEntregasHash() => r'87b0cdec405af11afb66ce05240ee127a43431a5';

final class MoliendaEntregasFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Entrega>>, String> {
  MoliendaEntregasFamily._()
    : super(
        retry: null,
        name: r'moliendaEntregasProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MoliendaEntregasProvider call(String moliendaId) =>
      MoliendaEntregasProvider._(argument: moliendaId, from: this);

  @override
  String toString() => r'moliendaEntregasProvider';
}

@ProviderFor(MoliendaForm)
final moliendaFormProvider = MoliendaFormProvider._();

final class MoliendaFormProvider
    extends $NotifierProvider<MoliendaForm, MoliendaFormState> {
  MoliendaFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'moliendaFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$moliendaFormHash();

  @$internal
  @override
  MoliendaForm create() => MoliendaForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MoliendaFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MoliendaFormState>(value),
    );
  }
}

String _$moliendaFormHash() => r'ca79080d2f92b152dbb1da10249a56eeb55666aa';

abstract class _$MoliendaForm extends $Notifier<MoliendaFormState> {
  MoliendaFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MoliendaFormState, MoliendaFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MoliendaFormState, MoliendaFormState>,
              MoliendaFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
