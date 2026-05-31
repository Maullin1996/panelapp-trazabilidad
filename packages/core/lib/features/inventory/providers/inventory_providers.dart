import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/datasources/inventory_firestore_datasource.dart';
import '../data/repositories/inventory_repository_impl.dart';
import '../domain/entities/inventory_item.dart';
import '../domain/repositories/inventory_repository.dart';

part 'inventory_providers.g.dart';

// ── Datasource ─────────────────────────────────────────────────────────────────
@riverpod
InventoryFirestoreDatasource inventoryDatasource(Ref ref) {
  return InventoryFirestoreDatasource(firestore: FirebaseFirestore.instance);
}

// ── Repository ─────────────────────────────────────────────────────────────────
@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  return InventoryRepositoryImpl(ref.watch(inventoryDatasourceProvider));
}

// ── Watch all ──────────────────────────────────────────────────────────────────
@riverpod
Stream<List<InventoryItem>> inventoryItems(Ref ref) {
  return ref.watch(inventoryRepositoryProvider).watchAll();
}

// ── Sync (lista sincrónica para usar en otros providers) ───────────────────────
@riverpod
List<InventoryItem> syncInventoryItems(Ref ref) {
  return ref
      .watch(inventoryItemsProvider)
      .maybeWhen(data: (data) => data, orElse: () => []);
}

@riverpod
Future<List<InventoryItem>> inventoryItemsFuture(Ref ref) async {
  return ref.read(inventoryRepositoryProvider).getAll();
}

// ── Form state ────────────────────────────────────────────────────────────────
enum InventoryFormStatus { initial, submitting, success, error }

class InventoryFormState {
  final InventoryFormStatus status;
  final String? errorMessage;

  const InventoryFormState({
    this.status = InventoryFormStatus.initial,
    this.errorMessage,
  });

  InventoryFormState copyWith({
    InventoryFormStatus? status,
    String? errorMessage,
  }) {
    return InventoryFormState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@riverpod
class InventoryForm extends _$InventoryForm {
  @override
  InventoryFormState build() => const InventoryFormState();

  Future<void> save(InventoryItem item, {required bool isNew}) async {
    state = state.copyWith(status: InventoryFormStatus.submitting);
    try {
      final repo = ref.read(inventoryRepositoryProvider);
      if (isNew) {
        await repo.create(item);
      } else {
        await repo.update(item);
      }
      state = state.copyWith(status: InventoryFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: InventoryFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> delete(String id) async {
    state = state.copyWith(status: InventoryFormStatus.submitting);
    try {
      await ref.read(inventoryRepositoryProvider).delete(id);
      state = state.copyWith(status: InventoryFormStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: InventoryFormStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> decrementAvailable(String id, int quantity) async {
    await ref
        .read(inventoryRepositoryProvider)
        .decrementAvailable(id, quantity);
  }

  Future<void> incrementAvailable(String id, int quantity) async {
    await ref
        .read(inventoryRepositoryProvider)
        .incrementAvailable(id, quantity);
  }
}
