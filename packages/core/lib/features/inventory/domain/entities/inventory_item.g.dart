// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    _InventoryItem(
      id: json['id'] as String,
      type: $enumDecode(_$InventoryItemTypeEnumMap, json['type']),
      totalUnits: (json['totalUnits'] as num).toInt(),
      availableUnits: (json['availableUnits'] as num).toInt(),
      referenceWeight: (json['referenceWeight'] as num?)?.toDouble(),
      gaveraType: json['gaveraType'] as String?,
      size: $enumDecodeNullable(_$BasketSizeEnumMap, json['size']),
    );

Map<String, dynamic> _$InventoryItemToJson(_InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$InventoryItemTypeEnumMap[instance.type]!,
      'totalUnits': instance.totalUnits,
      'availableUnits': instance.availableUnits,
      'referenceWeight': instance.referenceWeight,
      'gaveraType': instance.gaveraType,
      'size': _$BasketSizeEnumMap[instance.size],
    };

const _$InventoryItemTypeEnumMap = {
  InventoryItemType.gavera: 'gavera',
  InventoryItemType.canastilla: 'canastilla',
};

const _$BasketSizeEnumMap = {
  BasketSize.grande: 'grande',
  BasketSize.pequena: 'pequena',
};
