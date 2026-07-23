import 'package:registro_panela/features/stage1_delivery/domain/entities/stage1_form_data.dart';

import '../../domain/entities/inventory_item.dart';

class InventoryItemModel {
  final String id;
  final InventoryItemType type;
  final int totalUnits;
  final int availableUnits;
  final double? referenceWeight;
  final String? gaveraType; // ← String libre
  final BasketSize? size;

  InventoryItemModel({
    required this.id,
    required this.type,
    required this.totalUnits,
    required this.availableUnits,
    this.referenceWeight,
    this.gaveraType,
    this.size,
  });

  factory InventoryItemModel.fromEntity(InventoryItem item) {
    return InventoryItemModel(
      id: item.id,
      type: item.type,
      totalUnits: item.totalUnits,
      availableUnits: item.availableUnits,
      referenceWeight: item.referenceWeight,
      gaveraType: item.gaveraType,
      size: item.size,
    );
  }

  InventoryItem toEntity() {
    return InventoryItem(
      id: id,
      type: type,
      totalUnits: totalUnits,
      availableUnits: availableUnits,
      referenceWeight: referenceWeight,
      gaveraType: gaveraType,
      size: size,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'totalUnits': totalUnits,
      'availableUnits': availableUnits,
      if (referenceWeight != null) 'referenceWeight': referenceWeight,
      if (gaveraType != null) 'gaveraType': gaveraType,
      if (size != null) 'size': size!.name,
    };
  }

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as String,
      type: InventoryItemType.values.byName(json['type'] as String),
      totalUnits: (json['totalUnits'] as num).toInt(),
      availableUnits: (json['availableUnits'] as num).toInt(),
      referenceWeight: (json['referenceWeight'] as num?)?.toDouble(),
      gaveraType: json['gaveraType'] as String?,
      size: json['size'] != null
          ? BasketSize.values.byName(json['size'] as String)
          : null,
    );
  }
}
