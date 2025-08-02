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
mixin _$Stage1FormData {

 String get id; String get name; List<GaveraData> get gaveras; int get basketsQuantity; double get preservativesWeight; int get preservativesJars; double get limeWeight; int get limeJars; String get phone; DateTime get date; String? get photoPath;
/// Create a copy of Stage1FormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage1FormDataCopyWith<Stage1FormData> get copyWith => _$Stage1FormDataCopyWithImpl<Stage1FormData>(this as Stage1FormData, _$identity);

  /// Serializes this Stage1FormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage1FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.gaveras, gaveras)&&(identical(other.basketsQuantity, basketsQuantity) || other.basketsQuantity == basketsQuantity)&&(identical(other.preservativesWeight, preservativesWeight) || other.preservativesWeight == preservativesWeight)&&(identical(other.preservativesJars, preservativesJars) || other.preservativesJars == preservativesJars)&&(identical(other.limeWeight, limeWeight) || other.limeWeight == limeWeight)&&(identical(other.limeJars, limeJars) || other.limeJars == limeJars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.date, date) || other.date == date)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(gaveras),basketsQuantity,preservativesWeight,preservativesJars,limeWeight,limeJars,phone,date,photoPath);

@override
String toString() {
  return 'Stage1FormData(id: $id, name: $name, gaveras: $gaveras, basketsQuantity: $basketsQuantity, preservativesWeight: $preservativesWeight, preservativesJars: $preservativesJars, limeWeight: $limeWeight, limeJars: $limeJars, phone: $phone, date: $date, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $Stage1FormDataCopyWith<$Res>  {
  factory $Stage1FormDataCopyWith(Stage1FormData value, $Res Function(Stage1FormData) _then) = _$Stage1FormDataCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<GaveraData> gaveras, int basketsQuantity, double preservativesWeight, int preservativesJars, double limeWeight, int limeJars, String phone, DateTime date, String? photoPath
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? gaveras = null,Object? basketsQuantity = null,Object? preservativesWeight = null,Object? preservativesJars = null,Object? limeWeight = null,Object? limeJars = null,Object? phone = null,Object? date = null,Object? photoPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gaveras: null == gaveras ? _self.gaveras : gaveras // ignore: cast_nullable_to_non_nullable
as List<GaveraData>,basketsQuantity: null == basketsQuantity ? _self.basketsQuantity : basketsQuantity // ignore: cast_nullable_to_non_nullable
as int,preservativesWeight: null == preservativesWeight ? _self.preservativesWeight : preservativesWeight // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<GaveraData> gaveras,  int basketsQuantity,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
return $default(_that.id,_that.name,_that.gaveras,_that.basketsQuantity,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<GaveraData> gaveras,  int basketsQuantity,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)  $default,) {final _that = this;
switch (_that) {
case _Stage1FormData():
return $default(_that.id,_that.name,_that.gaveras,_that.basketsQuantity,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<GaveraData> gaveras,  int basketsQuantity,  double preservativesWeight,  int preservativesJars,  double limeWeight,  int limeJars,  String phone,  DateTime date,  String? photoPath)?  $default,) {final _that = this;
switch (_that) {
case _Stage1FormData() when $default != null:
return $default(_that.id,_that.name,_that.gaveras,_that.basketsQuantity,_that.preservativesWeight,_that.preservativesJars,_that.limeWeight,_that.limeJars,_that.phone,_that.date,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage1FormData implements Stage1FormData {
  const _Stage1FormData({required this.id, required this.name, required final  List<GaveraData> gaveras, required this.basketsQuantity, required this.preservativesWeight, required this.preservativesJars, required this.limeWeight, required this.limeJars, required this.phone, required this.date, this.photoPath}): _gaveras = gaveras;
  factory _Stage1FormData.fromJson(Map<String, dynamic> json) => _$Stage1FormDataFromJson(json);

@override final  String id;
@override final  String name;
 final  List<GaveraData> _gaveras;
@override List<GaveraData> get gaveras {
  if (_gaveras is EqualUnmodifiableListView) return _gaveras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_gaveras);
}

@override final  int basketsQuantity;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage1FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._gaveras, _gaveras)&&(identical(other.basketsQuantity, basketsQuantity) || other.basketsQuantity == basketsQuantity)&&(identical(other.preservativesWeight, preservativesWeight) || other.preservativesWeight == preservativesWeight)&&(identical(other.preservativesJars, preservativesJars) || other.preservativesJars == preservativesJars)&&(identical(other.limeWeight, limeWeight) || other.limeWeight == limeWeight)&&(identical(other.limeJars, limeJars) || other.limeJars == limeJars)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.date, date) || other.date == date)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_gaveras),basketsQuantity,preservativesWeight,preservativesJars,limeWeight,limeJars,phone,date,photoPath);

@override
String toString() {
  return 'Stage1FormData(id: $id, name: $name, gaveras: $gaveras, basketsQuantity: $basketsQuantity, preservativesWeight: $preservativesWeight, preservativesJars: $preservativesJars, limeWeight: $limeWeight, limeJars: $limeJars, phone: $phone, date: $date, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$Stage1FormDataCopyWith<$Res> implements $Stage1FormDataCopyWith<$Res> {
  factory _$Stage1FormDataCopyWith(_Stage1FormData value, $Res Function(_Stage1FormData) _then) = __$Stage1FormDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<GaveraData> gaveras, int basketsQuantity, double preservativesWeight, int preservativesJars, double limeWeight, int limeJars, String phone, DateTime date, String? photoPath
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? gaveras = null,Object? basketsQuantity = null,Object? preservativesWeight = null,Object? preservativesJars = null,Object? limeWeight = null,Object? limeJars = null,Object? phone = null,Object? date = null,Object? photoPath = freezed,}) {
  return _then(_Stage1FormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,gaveras: null == gaveras ? _self._gaveras : gaveras // ignore: cast_nullable_to_non_nullable
as List<GaveraData>,basketsQuantity: null == basketsQuantity ? _self.basketsQuantity : basketsQuantity // ignore: cast_nullable_to_non_nullable
as int,preservativesWeight: null == preservativesWeight ? _self.preservativesWeight : preservativesWeight // ignore: cast_nullable_to_non_nullable
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


/// @nodoc
mixin _$GaveraData {

 int get quantity; double get referenceWeight;
/// Create a copy of GaveraData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GaveraDataCopyWith<GaveraData> get copyWith => _$GaveraDataCopyWithImpl<GaveraData>(this as GaveraData, _$identity);

  /// Serializes this GaveraData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GaveraData&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight);

@override
String toString() {
  return 'GaveraData(quantity: $quantity, referenceWeight: $referenceWeight)';
}


}

/// @nodoc
abstract mixin class $GaveraDataCopyWith<$Res>  {
  factory $GaveraDataCopyWith(GaveraData value, $Res Function(GaveraData) _then) = _$GaveraDataCopyWithImpl;
@useResult
$Res call({
 int quantity, double referenceWeight
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
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? referenceWeight = null,}) {
  return _then(_self.copyWith(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int quantity,  double referenceWeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
return $default(_that.quantity,_that.referenceWeight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int quantity,  double referenceWeight)  $default,) {final _that = this;
switch (_that) {
case _GaveraData():
return $default(_that.quantity,_that.referenceWeight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int quantity,  double referenceWeight)?  $default,) {final _that = this;
switch (_that) {
case _GaveraData() when $default != null:
return $default(_that.quantity,_that.referenceWeight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GaveraData implements GaveraData {
  const _GaveraData({this.quantity = 0, required this.referenceWeight});
  factory _GaveraData.fromJson(Map<String, dynamic> json) => _$GaveraDataFromJson(json);

@override@JsonKey() final  int quantity;
@override final  double referenceWeight;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GaveraData&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight);

@override
String toString() {
  return 'GaveraData(quantity: $quantity, referenceWeight: $referenceWeight)';
}


}

/// @nodoc
abstract mixin class _$GaveraDataCopyWith<$Res> implements $GaveraDataCopyWith<$Res> {
  factory _$GaveraDataCopyWith(_GaveraData value, $Res Function(_GaveraData) _then) = __$GaveraDataCopyWithImpl;
@override @useResult
$Res call({
 int quantity, double referenceWeight
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
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? referenceWeight = null,}) {
  return _then(_GaveraData(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
