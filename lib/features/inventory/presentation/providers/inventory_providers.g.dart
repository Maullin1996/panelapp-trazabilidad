// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryDatasource)
final inventoryDatasourceProvider = InventoryDatasourceProvider._();

final class InventoryDatasourceProvider
    extends
        $FunctionalProvider<
          InventoryFirestoreDatasource,
          InventoryFirestoreDatasource,
          InventoryFirestoreDatasource
        >
    with $Provider<InventoryFirestoreDatasource> {
  InventoryDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryDatasourceHash();

  @$internal
  @override
  $ProviderElement<InventoryFirestoreDatasource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryFirestoreDatasource create(Ref ref) {
    return inventoryDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryFirestoreDatasource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryFirestoreDatasource>(value),
    );
  }
}

String _$inventoryDatasourceHash() =>
    r'6653223b7f49c786ac2cc373456eb2cdc07a7f92';

@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider = InventoryRepositoryProvider._();

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'ed7db104bd2c8ba6acf44cc01cae4df41cab359b';

@ProviderFor(inventoryItems)
final inventoryItemsProvider = InventoryItemsProvider._();

final class InventoryItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItem>>,
          List<InventoryItem>,
          Stream<List<InventoryItem>>
        >
    with
        $FutureModifier<List<InventoryItem>>,
        $StreamProvider<List<InventoryItem>> {
  InventoryItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InventoryItem>> create(Ref ref) {
    return inventoryItems(ref);
  }
}

String _$inventoryItemsHash() => r'f7b89b7f6111a352f271f1ac104f898b216c143a';

@ProviderFor(syncInventoryItems)
final syncInventoryItemsProvider = SyncInventoryItemsProvider._();

final class SyncInventoryItemsProvider
    extends
        $FunctionalProvider<
          List<InventoryItem>,
          List<InventoryItem>,
          List<InventoryItem>
        >
    with $Provider<List<InventoryItem>> {
  SyncInventoryItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncInventoryItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncInventoryItemsHash();

  @$internal
  @override
  $ProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<InventoryItem> create(Ref ref) {
    return syncInventoryItems(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<InventoryItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<InventoryItem>>(value),
    );
  }
}

String _$syncInventoryItemsHash() =>
    r'd94d858707e94bb1f2950515bf08c32a69b24955';

@ProviderFor(inventoryItemsFuture)
final inventoryItemsFutureProvider = InventoryItemsFutureProvider._();

final class InventoryItemsFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItem>>,
          List<InventoryItem>,
          FutureOr<List<InventoryItem>>
        >
    with
        $FutureModifier<List<InventoryItem>>,
        $FutureProvider<List<InventoryItem>> {
  InventoryItemsFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryItemsFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryItemsFutureHash();

  @$internal
  @override
  $FutureProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItem>> create(Ref ref) {
    return inventoryItemsFuture(ref);
  }
}

String _$inventoryItemsFutureHash() =>
    r'738ba9a7306f9d1a83e517aec3def5c37200120c';

@ProviderFor(InventoryForm)
final inventoryFormProvider = InventoryFormProvider._();

final class InventoryFormProvider
    extends $NotifierProvider<InventoryForm, InventoryFormState> {
  InventoryFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryFormHash();

  @$internal
  @override
  InventoryForm create() => InventoryForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryFormState>(value),
    );
  }
}

String _$inventoryFormHash() => r'3991efbce8d08808ac9e08da33486259d9f3c094';

abstract class _$InventoryForm extends $Notifier<InventoryFormState> {
  InventoryFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InventoryFormState, InventoryFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InventoryFormState, InventoryFormState>,
              InventoryFormState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
