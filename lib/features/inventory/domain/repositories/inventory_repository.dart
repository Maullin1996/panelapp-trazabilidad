import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<void> create(InventoryItem item);
  Future<void> update(InventoryItem item);
  Future<void> delete(String id);
  Stream<List<InventoryItem>> watchAll();
  Future<void> decrementAvailable(String id, int quantity);
  Future<void> incrementAvailable(String id, int quantity);
  Future<List<InventoryItem>> getAll();
}
