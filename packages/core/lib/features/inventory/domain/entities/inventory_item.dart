import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:core/features/stage1_delivery/domain/entities/stage1_form_data.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

enum InventoryItemType { gavera, canastilla }

@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    required InventoryItemType type,
    required int totalUnits,
    required int availableUnits,

    // Solo gavera
    double? referenceWeight,
    String? gaveraType,

    // Solo canastilla
    BasketSize? size,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}
