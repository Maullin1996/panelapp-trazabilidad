// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage1_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GaveraData {

 int get quantity; double get referenceWeight; String get gaveraType;
/// Create a copy of GaveraData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GaveraDataCopyWith<GaveraData> get copyWith => _$GaveraDataCopyWithImpl<GaveraData>(this as GaveraData, _$identity);

  /// Serializes this GaveraData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GaveraData&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.gaveraType, gaveraType) || other.gaveraType == gaveraType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight,gaveraType);

@override
String toString() {
  return 'GaveraData(quantity: $quantity, referenceWeight: $referenceWeight, gaveraType: $gaveraType)';
}


}

/// @nodoc
abstract mixin class $GaveraDataCopyWith<$Res>  {
  factory $GaveraDataCopyWith(GaveraData value, $Res Function(GaveraData) _then) = _$GaveraDataCopyWithImpl;
@useResult
$Res call({
 int quantity, double referenceWeight, String gaveraType
});




}
/// @nodoc
class _$GaveraDataCopyWithImpl<$Res>
    implements $GaveraDataCopyWith<$Res> {
  _$GaveraDataCopyWithImpl(this._self, this._then);

  final GaveraData _self;
  final $Res Function(GaveraData) _then;

/// Create a copy of GaveraData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? referenceWeight = null,Object? gaveraType = null,}) {
  return _then(_self.copyWith(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,gaveraType: null == gaveraType ? _self.gaveraType : gaveraType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GaveraData].
extension GaveraDataPatterns on GaveraData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GaveraData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GaveraData value)  $default,){
final _that = this;
switch (_that) {
case _GaveraData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GaveraData value)?  $default,){
final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quantity,  double referenceWeight,  String gaveraType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
return $default(_that.quantity,_that.referenceWeight,_that.gaveraType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quantity,  double referenceWeight,  String gaveraType)  $default,) {final _that = this;
switch (_that) {
case _GaveraData():
return $default(_that.quantity,_that.referenceWeight,_that.gaveraType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quantity,  double referenceWeight,  String gaveraType)?  $default,) {final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
return $default(_that.quantity,_that.referenceWeight,_that.gaveraType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GaveraData implements GaveraData {
  const _GaveraData({this.quantity = 0, required this.referenceWeight, this.gaveraType = ''});
  factory _GaveraData.fromJson(Map<String, dynamic> json) => _$GaveraDataFromJson(json);

@override@JsonKey() final  int quantity;
@override final  double referenceWeight;
@override@JsonKey() final  String gaveraType;

/// Create a copy of GaveraData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GaveraDataCopyWith<_GaveraData> get copyWith => __$GaveraDataCopyWithImpl<_GaveraData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GaveraDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GaveraData&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.gaveraType, gaveraType) || other.gaveraType == gaveraType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight,gaveraType);

@override
String toString() {
  return 'GaveraData(quantity: $quantity, referenceWeight: $referenceWeight, gaveraType: $gaveraType)';
}


}

/// @nodoc
abstract mixin class _$GaveraDataCopyWith<$Res> implements $GaveraDataCopyWith<$Res> {
  factory _$GaveraDataCopyWith(_GaveraData value, $Res Function(_GaveraData) _then) = __$GaveraDataCopyWithImpl;
@override @useResult
$Res call({
 int quantity, double referenceWeight, String gaveraType
});




}
/// @nodoc
class __$GaveraDataCopyWithImpl<$Res>
    implements _$GaveraDataCopyWith<$Res> {
  __$GaveraDataCopyWithImpl(this._self, this._then);

  final _GaveraData _self;
  final $Res Function(_GaveraData) _then;

/// Create a copy of GaveraData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? referenceWeight = null,Object? gaveraType = null,}) {
  return _then(_GaveraData(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,gaveraType: null == gaveraType ? _self.gaveraType : gaveraType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$BasketData {

 BasketSize get size; int get quantity;
/// Create a copy of BasketData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketDataCopyWith<BasketData> get copyWith => _$BasketDataCopyWithImpl<BasketData>(this as BasketData, _$identity);

  /// Serializes this BasketData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketData&&(identical(other.size, size) || other.size == size)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,quantity);

@override
String toString() {
  return 'BasketData(size: $size, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $BasketDataCopyWith<$Res>  {
  factory $BasketDataCopyWith(BasketData value, $Res Function(BasketData) _then) = _$BasketDataCopyWithImpl;
@useResult
$Res call({
 BasketSize size, int quantity
});




}
/// @nodoc
class _$BasketDataCopyWithImpl<$Res>
    implements $BasketDataCopyWith<$Res> {
  _$BasketDataCopyWithImpl(this._self, this._then);

  final BasketData _self;
  final $Res Function(BasketData) _then;

/// Create a copy of BasketData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? size = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BasketSize,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketData].
extension BasketDataPatterns on BasketData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketData value)  $default,){
final _that = this;
switch (_that) {
case _BasketData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketData value)?  $default,){
final _that = this;
switch (_that) {
case _BasketData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BasketSize size,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketData() when $default != null:
return $default(_that.size,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BasketSize size,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _BasketData():
return $default(_that.size,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BasketSize size,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _BasketData() when $default != null:
return $default(_that.size,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasketData implements BasketData {
  const _BasketData({required this.size, this.quantity = 0});
  factory _BasketData.fromJson(Map<String, dynamic> json) => _$BasketDataFromJson(json);

@override final  BasketSize size;
@override@JsonKey() final  int quantity;

/// Create a copy of BasketData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketDataCopyWith<_BasketData> get copyWith => __$BasketDataCopyWithImpl<_BasketData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasketDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketData&&(identical(other.size, size) || other.size == size)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,size,quantity);

@override
String toString() {
  return 'BasketData(size: $size, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$BasketDataCopyWith<$Res> implements $BasketDataCopyWith<$Res> {
  factory _$BasketDataCopyWith(_BasketData value, $Res Function(_BasketData) _then) = __$BasketDataCopyWithImpl;
@override @useResult
$Res call({
 BasketSize size, int quantity
});




}
/// @nodoc
class __$BasketDataCopyWithImpl<$Res>
    implements _$BasketDataCopyWith<$Res> {
  __$BasketDataCopyWithImpl(this._self, this._then);

  final _BasketData _self;
  final $Res Function(_BasketData) _then;

/// Create a copy of BasketData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? size = null,Object? quantity = null,}) {
  return _then(_BasketData(
size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as BasketSize,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Stage1FormData {

 String get id; String get name; String? get moliendaId; List<GaveraData> get gaveras; List<BasketData> get baskets; double get preservativesWeight; int get preservativesJars; double get limeWeight; int get limeJars; String get phone; DateTime get date; String? get photoPath;
/// Create a copy of Stage1FormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage1FormDataCopyWith<Stage1FormData> get copyWith => _$Stage1FormDataCopyWithImpl<Stage1FormData>(this as Stage1FormData, _$identity);

  /// Serializes this Stage1FormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage1FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.moliendaId, moliendaId) || other.moliendaId == moliendaId)&&const DeepCollectionEquality().equals(other.gaveras, gaveras)&&const DeepCollectionEquality().equals(other.baskets, baskets)&&(identical(other.preservativesWeight, preservativesWeight) || other.preservativesWeight == preservativesWeight)&&(identical(other.preservativesJars, preservativesJars) || other.preservativesJars == preservativesJars)&&(identical(other.limeWeight, limeWeight) || other.limeWeight == limeWeight)&&(identical(other.limeJars, limeJars) || other.limeJars == limeJars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.date, date) || other.date == date)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,moliendaId,const DeepCollectionEquality().hash(gaveras),const DeepCollectionEquality().hash(baskets),preservativesWeight,preservativesJars,limeWeight,limeJars,phone,date,photoPath);

@override
String toString() {
  return 'Stage1FormData(id: $id, name: $name, moliendaId: $moliendaId, gaveras: $gaveras, baskets: $baskets, preservativesWeight: $preservativesWeight, preservativesJars: $preservativesJars, limeWeight: $limeWeight, limeJars: $limeJars, phone: $phone, date: $date, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $Stage1FormDataCopyWith<$Res>  {
  factory $Stage1FormDataCopyWith(Stage1FormData value, $Res Function(Stage1FormData) _then) = _$Stage1FormDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? moliendaId, List<GaveraData> gaveras, List<BasketData> baskets, double preservativesWeight, int preservativesJars, double limeWeight, int limeJars, String phone, DateTime date, String? photoPath
});




}
/// @nodoc
class _$Stage1FormDataCopyWithImpl<$Res>
    implements $Stage1FormDataCopyWith<$Res> {
  _$Stage1FormDataCopyWithImpl(this._self, this._then);

  final Stage1FormData _self;
  final $Res Function(Stage1FormData) _then;

/// Create a copy of Stage1FormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? moliendaId = freezed,Object? gaveras = null,Object? baskets = null,Object? preservativesWeight = null,Object? preservativesJars = null,Object? limeWeight = null,Object? limeJars = null,Object? phone = null,Object? date = null,Object? photoPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moliendaId: freezed == moliendaId ? _self.moliendaId : moliendaId // ignore: cast_nullable_to_non_nullable
as String?,gaveras: null == gaveras ? _self.gaveras : gaveras // ignore: cast_nullable_to_non_nullable
as List<GaveraData>,baskets: null == baskets ? _self.baskets : baskets // ignore: cast_nullable_to_non_nullable
as List<BasketData>,preservativesWeight: null == preservativesWeight ? _self.preservativesWeight : preservativesWeight // ignore: cast_nullable_to_non_nullable
as double,preservativesJars: null == preservativesJars ? _self.preservativesJars : preservativesJars // ignore: cast_nullable_to_non_nullable
as int,limeWeight: null == limeWeight ? _self.limeWeight : limeWeight // ignore: cast_nullable_to_non_nullable
as double,limeJars: null == limeJars ? _self.limeJars : limeJars // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage1FormData].
extension Stage1FormDataPatterns on Stage1FormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage1FormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage1FormData value)  $default,){
final _that = this;
switch (_that) {
case _Stage1FormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage1FormData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? moliendaId,  List<GaveraData> gaveras,  List<BasketData> baskets,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
return $default(_that.id,_that.name,_that.moliendaId,_that.gaveras,_that.baskets,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? moliendaId,  List<GaveraData> gaveras,  List<BasketData> baskets,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _Stage1FormData():
return $default(_that.id,_that.name,_that.moliendaId,_that.gaveras,_that.baskets,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? moliendaId,  List<GaveraData> gaveras,  List<BasketData> baskets,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
return $default(_that.id,_that.name,_that.moliendaId,_that.gaveras,_that.baskets,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage1FormData implements Stage1FormData {
  const _Stage1FormData({required this.id, required this.name, this.moliendaId, required final  List<GaveraData> gaveras, required final  List<BasketData> baskets, required this.preservativesWeight, required this.preservativesJars, required this.limeWeight, required this.limeJars, required this.phone, required this.date, this.photoPath}): _gaveras = gaveras,_baskets = baskets;
  factory _Stage1FormData.fromJson(Map<String, dynamic> json) => _$Stage1FormDataFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? moliendaId;
 final  List<GaveraData> _gaveras;
@override List<GaveraData> get gaveras {
  if (_gaveras is EqualUnmodifiableListView) return _gaveras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gaveras);
}

 final  List<BasketData> _baskets;
@override List<BasketData> get baskets {
  if (_baskets is EqualUnmodifiableListView) return _baskets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_baskets);
}

@override final  double preservativesWeight;
@override final  int preservativesJars;
@override final  double limeWeight;
@override final  int limeJars;
@override final  String phone;
@override final  DateTime date;
@override final  String? photoPath;

/// Create a copy of Stage1FormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage1FormDataCopyWith<_Stage1FormData> get copyWith => __$Stage1FormDataCopyWithImpl<_Stage1FormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage1FormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage1FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.moliendaId, moliendaId) || other.moliendaId == moliendaId)&&const DeepCollectionEquality().equals(other._gaveras, _gaveras)&&const DeepCollectionEquality().equals(other._baskets, _baskets)&&(identical(other.preservativesWeight, preservativesWeight) || other.preservativesWeight == preservativesWeight)&&(identical(other.preservativesJars, preservativesJars) || other.preservativesJars == preservativesJars)&&(identical(other.limeWeight, limeWeight) || other.limeWeight == limeWeight)&&(identical(other.limeJars, limeJars) || other.limeJars == limeJars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.date, date) || other.date == date)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,moliendaId,const DeepCollectionEquality().hash(_gaveras),const DeepCollectionEquality().hash(_baskets),preservativesWeight,preservativesJars,limeWeight,limeJars,phone,date,photoPath);

@override
String toString() {
  return 'Stage1FormData(id: $id, name: $name, moliendaId: $moliendaId, gaveras: $gaveras, baskets: $baskets, preservativesWeight: $preservativesWeight, preservativesJars: $preservativesJars, limeWeight: $limeWeight, limeJars: $limeJars, phone: $phone, date: $date, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$Stage1FormDataCopyWith<$Res> implements $Stage1FormDataCopyWith<$Res> {
  factory _$Stage1FormDataCopyWith(_Stage1FormData value, $Res Function(_Stage1FormData) _then) = __$Stage1FormDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? moliendaId, List<GaveraData> gaveras, List<BasketData> baskets, double preservativesWeight, int preservativesJars, double limeWeight, int limeJars, String phone, DateTime date, String? photoPath
});




}
/// @nodoc
class __$Stage1FormDataCopyWithImpl<$Res>
    implements _$Stage1FormDataCopyWith<$Res> {
  __$Stage1FormDataCopyWithImpl(this._self, this._then);

  final _Stage1FormData _self;
  final $Res Function(_Stage1FormData) _then;

/// Create a copy of Stage1FormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? moliendaId = freezed,Object? gaveras = null,Object? baskets = null,Object? preservativesWeight = null,Object? preservativesJars = null,Object? limeWeight = null,Object? limeJars = null,Object? phone = null,Object? date = null,Object? photoPath = freezed,}) {
  return _then(_Stage1FormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,moliendaId: freezed == moliendaId ? _self.moliendaId : moliendaId // ignore: cast_nullable_to_non_nullable
as String?,gaveras: null == gaveras ? _self._gaveras : gaveras // ignore: cast_nullable_to_non_nullable
as List<GaveraData>,baskets: null == baskets ? _self._baskets : baskets // ignore: cast_nullable_to_non_nullable
as List<BasketData>,preservativesWeight: null == preservativesWeight ? _self.preservativesWeight : preservativesWeight // ignore: cast_nullable_to_non_nullable
as double,preservativesJars: null == preservativesJars ? _self.preservativesJars : preservativesJars // ignore: cast_nullable_to_non_nullable
as int,limeWeight: null == limeWeight ? _self.limeWeight : limeWeight // ignore: cast_nullable_to_non_nullable
as double,limeJars: null == limeJars ? _self.limeJars : limeJars // ignore: cast_nullable_to_non_nullable
as int,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
