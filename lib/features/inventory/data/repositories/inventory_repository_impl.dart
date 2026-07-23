import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_firestore_datasource.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryFirestoreDatasource datasource;

  InventoryRepositoryImpl(this.datasource);

  @override
  Future<void> create(InventoryItem item) {
    return datasource.create(InventoryItemModel.fromEntity(item));
  }

  @override
  Future<void> update(InventoryItem item) {
    return datasource.update(InventoryItemModel.fromEntity(item));
  }

  @override
  Future<void> delete(String id) {
    return datasource.delete(id);
  }

  @override
  Stream<List<InventoryItem>> watchAll() {
    return datasource.watchAll().map(
      (models) => models.map((m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<void> decrementAvailable(String id, int quantity) {
    return datasource.decrementAvailable(id, quantity);
  }

  @override
  Future<void> incrementAvailable(String id, int quantity) {
    return datasource.incrementAvailable(id, quantity);
  }

  @override
  Future<List<InventoryItem>> getAll() async {
    final models = await datasource.getAll();
    return models.map((m) => m.toEntity()).toList();
  }
}
