// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryItem {

 String get id; InventoryItemType get type; int get totalUnits; int get availableUnits;// Solo gavera
 double? get referenceWeight; String? get gaveraType;// Solo canastilla
 BasketSize? get size;
/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryItemCopyWith<InventoryItem> get copyWith => _$InventoryItemCopyWithImpl<InventoryItem>(this as InventoryItem, _$identity);

  /// Serializes this InventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalUnits, totalUnits) || other.totalUnits == totalUnits)&&(identical(other.availableUnits, availableUnits) || other.availableUnits == availableUnits)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.gaveraType, gaveraType) || other.gaveraType == gaveraType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,totalUnits,availableUnits,referenceWeight,gaveraType,size);

@override
String toString() {
  return 'InventoryItem(id: $id, type: $type, totalUnits: $totalUnits, availableUnits: $availableUnits, referenceWeight: $referenceWeight, gaveraType: $gaveraType, size: $size)';
}


}

/// @nodoc
abstract mixin class $InventoryItemCopyWith<$Res>  {
  factory $InventoryItemCopyWith(InventoryItem value, $Res Function(InventoryItem) _then) = _$InventoryItemCopyWithImpl;
@useResult
$Res call({
 String id, InventoryItemType type, int totalUnits, int availableUnits, double? referenceWeight, String? gaveraType, BasketSize? size
});




}
/// @nodoc
class _$InventoryItemCopyWithImpl<$Res>
    implements $InventoryItemCopyWith<$Res> {
  _$InventoryItemCopyWithImpl(this._self, this._then);

  final InventoryItem _self;
  final $Res Function(InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? totalUnits = null,Object? availableUnits = null,Object? referenceWeight = freezed,Object? gaveraType = freezed,Object? size = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InventoryItemType,totalUnits: null == totalUnits ? _self.totalUnits : totalUnits // ignore: cast_nullable_to_non_nullable
as int,availableUnits: null == availableUnits ? _self.availableUnits : availableUnits // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: freezed == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double?,gaveraType: freezed == gaveraType ? _self.gaveraType : gaveraType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BasketSize?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryItem].
extension InventoryItemPatterns on InventoryItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  InventoryItemType type,  int totalUnits,  int availableUnits,  double? referenceWeight,  String? gaveraType,  BasketSize? size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.type,_that.totalUnits,_that.availableUnits,_that.referenceWeight,_that.gaveraType,_that.size);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  InventoryItemType type,  int totalUnits,  int availableUnits,  double? referenceWeight,  String? gaveraType,  BasketSize? size)  $default,) {final _that = this;
switch (_that) {
case _InventoryItem():
return $default(_that.id,_that.type,_that.totalUnits,_that.availableUnits,_that.referenceWeight,_that.gaveraType,_that.size);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  InventoryItemType type,  int totalUnits,  int availableUnits,  double? referenceWeight,  String? gaveraType,  BasketSize? size)?  $default,) {final _that = this;
switch (_that) {
case _InventoryItem() when $default != null:
return $default(_that.id,_that.type,_that.totalUnits,_that.availableUnits,_that.referenceWeight,_that.gaveraType,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryItem implements InventoryItem {
  const _InventoryItem({required this.id, required this.type, required this.totalUnits, required this.availableUnits, this.referenceWeight, this.gaveraType, this.size});
  factory _InventoryItem.fromJson(Map<String, dynamic> json) => _$InventoryItemFromJson(json);

@override final  String id;
@override final  InventoryItemType type;
@override final  int totalUnits;
@override final  int availableUnits;
// Solo gavera
@override final  double? referenceWeight;
@override final  String? gaveraType;
// Solo canastilla
@override final  BasketSize? size;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryItemCopyWith<_InventoryItem> get copyWith => __$InventoryItemCopyWithImpl<_InventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.totalUnits, totalUnits) || other.totalUnits == totalUnits)&&(identical(other.availableUnits, availableUnits) || other.availableUnits == availableUnits)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.gaveraType, gaveraType) || other.gaveraType == gaveraType)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,totalUnits,availableUnits,referenceWeight,gaveraType,size);

@override
String toString() {
  return 'InventoryItem(id: $id, type: $type, totalUnits: $totalUnits, availableUnits: $availableUnits, referenceWeight: $referenceWeight, gaveraType: $gaveraType, size: $size)';
}


}

/// @nodoc
abstract mixin class _$InventoryItemCopyWith<$Res> implements $InventoryItemCopyWith<$Res> {
  factory _$InventoryItemCopyWith(_InventoryItem value, $Res Function(_InventoryItem) _then) = __$InventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, InventoryItemType type, int totalUnits, int availableUnits, double? referenceWeight, String? gaveraType, BasketSize? size
});




}
/// @nodoc
class __$InventoryItemCopyWithImpl<$Res>
    implements _$InventoryItemCopyWith<$Res> {
  __$InventoryItemCopyWithImpl(this._self, this._then);

  final _InventoryItem _self;
  final $Res Function(_InventoryItem) _then;

/// Create a copy of InventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? totalUnits = null,Object? availableUnits = null,Object? referenceWeight = freezed,Object? gaveraType = freezed,Object? size = freezed,}) {
  return _then(_InventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InventoryItemType,totalUnits: null == totalUnits ? _self.totalUnits : totalUnits // ignore: cast_nullable_to_non_nullable
as int,availableUnits: null == availableUnits ? _self.availableUnits : availableUnits // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: freezed == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double?,gaveraType: freezed == gaveraType ? _self.gaveraType : gaveraType // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BasketSize?,
  ));
}


}

// dart format on
