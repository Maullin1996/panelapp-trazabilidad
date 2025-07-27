// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage2_load_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stage2LoadData {

 String get id; String get projectId; DateTime get date; BasketLoadData get baskets;
/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage2LoadDataCopyWith<Stage2LoadData> get copyWith => _$Stage2LoadDataCopyWithImpl<Stage2LoadData>(this as Stage2LoadData, _$identity);

  /// Serializes this Stage2LoadData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage2LoadData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.baskets, baskets) || other.baskets == baskets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,baskets);

@override
String toString() {
  return 'Stage2LoadData(id: $id, projectId: $projectId, date: $date, baskets: $baskets)';
}


}

/// @nodoc
abstract mixin class $Stage2LoadDataCopyWith<$Res>  {
  factory $Stage2LoadDataCopyWith(Stage2LoadData value, $Res Function(Stage2LoadData) _then) = _$Stage2LoadDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, DateTime date, BasketLoadData baskets
});


$BasketLoadDataCopyWith<$Res> get baskets;

}
/// @nodoc
class _$Stage2LoadDataCopyWithImpl<$Res>
    implements $Stage2LoadDataCopyWith<$Res> {
  _$Stage2LoadDataCopyWithImpl(this._self, this._then);

  final Stage2LoadData _self;
  final $Res Function(Stage2LoadData) _then;

/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? baskets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,baskets: null == baskets ? _self.baskets : baskets // ignore: cast_nullable_to_non_nullable
as BasketLoadData,
  ));
}
/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BasketLoadDataCopyWith<$Res> get baskets {
  
  return $BasketLoadDataCopyWith<$Res>(_self.baskets, (value) {
    return _then(_self.copyWith(baskets: value));
  });
}
}


/// Adds pattern-matching-related methods to [Stage2LoadData].
extension Stage2LoadDataPatterns on Stage2LoadData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage2LoadData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage2LoadData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage2LoadData value)  $default,){
final _that = this;
switch (_that) {
case _Stage2LoadData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage2LoadData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage2LoadData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  BasketLoadData baskets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage2LoadData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.baskets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  BasketLoadData baskets)  $default,) {final _that = this;
switch (_that) {
case _Stage2LoadData():
return $default(_that.id,_that.projectId,_that.date,_that.baskets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  DateTime date,  BasketLoadData baskets)?  $default,) {final _that = this;
switch (_that) {
case _Stage2LoadData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.baskets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage2LoadData implements Stage2LoadData {
  const _Stage2LoadData({required this.id, required this.projectId, required this.date, required this.baskets});
  factory _Stage2LoadData.fromJson(Map<String, dynamic> json) => _$Stage2LoadDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  DateTime date;
@override final  BasketLoadData baskets;

/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage2LoadDataCopyWith<_Stage2LoadData> get copyWith => __$Stage2LoadDataCopyWithImpl<_Stage2LoadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage2LoadDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage2LoadData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.baskets, baskets) || other.baskets == baskets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,baskets);

@override
String toString() {
  return 'Stage2LoadData(id: $id, projectId: $projectId, date: $date, baskets: $baskets)';
}


}

/// @nodoc
abstract mixin class _$Stage2LoadDataCopyWith<$Res> implements $Stage2LoadDataCopyWith<$Res> {
  factory _$Stage2LoadDataCopyWith(_Stage2LoadData value, $Res Function(_Stage2LoadData) _then) = __$Stage2LoadDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, DateTime date, BasketLoadData baskets
});


@override $BasketLoadDataCopyWith<$Res> get baskets;

}
/// @nodoc
class __$Stage2LoadDataCopyWithImpl<$Res>
    implements _$Stage2LoadDataCopyWith<$Res> {
  __$Stage2LoadDataCopyWithImpl(this._self, this._then);

  final _Stage2LoadData _self;
  final $Res Function(_Stage2LoadData) _then;

/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? baskets = null,}) {
  return _then(_Stage2LoadData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,baskets: null == baskets ? _self.baskets : baskets // ignore: cast_nullable_to_non_nullable
as BasketLoadData,
  ));
}

/// Create a copy of Stage2LoadData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BasketLoadDataCopyWith<$Res> get baskets {
  
  return $BasketLoadDataCopyWith<$Res>(_self.baskets, (value) {
    return _then(_self.copyWith(baskets: value));
  });
}
}


/// @nodoc
mixin _$BasketLoadData {

 double get referenceWeight; int get count; double get realWeight;
/// Create a copy of BasketLoadData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketLoadDataCopyWith<BasketLoadData> get copyWith => _$BasketLoadDataCopyWithImpl<BasketLoadData>(this as BasketLoadData, _$identity);

  /// Serializes this BasketLoadData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketLoadData&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.count, count) || other.count == count)&&(identical(other.realWeight, realWeight) || other.realWeight == realWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referenceWeight,count,realWeight);

@override
String toString() {
  return 'BasketLoadData(referenceWeight: $referenceWeight, count: $count, realWeight: $realWeight)';
}


}

/// @nodoc
abstract mixin class $BasketLoadDataCopyWith<$Res>  {
  factory $BasketLoadDataCopyWith(BasketLoadData value, $Res Function(BasketLoadData) _then) = _$BasketLoadDataCopyWithImpl;
@useResult
$Res call({
 double referenceWeight, int count, double realWeight
});




}
/// @nodoc
class _$BasketLoadDataCopyWithImpl<$Res>
    implements $BasketLoadDataCopyWith<$Res> {
  _$BasketLoadDataCopyWithImpl(this._self, this._then);

  final BasketLoadData _self;
  final $Res Function(BasketLoadData) _then;

/// Create a copy of BasketLoadData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? referenceWeight = null,Object? count = null,Object? realWeight = null,}) {
  return _then(_self.copyWith(
referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,realWeight: null == realWeight ? _self.realWeight : realWeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketLoadData].
extension BasketLoadDataPatterns on BasketLoadData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketLoadData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketLoadData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketLoadData value)  $default,){
final _that = this;
switch (_that) {
case _BasketLoadData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketLoadData value)?  $default,){
final _that = this;
switch (_that) {
case _BasketLoadData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double referenceWeight,  int count,  double realWeight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketLoadData() when $default != null:
return $default(_that.referenceWeight,_that.count,_that.realWeight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double referenceWeight,  int count,  double realWeight)  $default,) {final _that = this;
switch (_that) {
case _BasketLoadData():
return $default(_that.referenceWeight,_that.count,_that.realWeight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double referenceWeight,  int count,  double realWeight)?  $default,) {final _that = this;
switch (_that) {
case _BasketLoadData() when $default != null:
return $default(_that.referenceWeight,_that.count,_that.realWeight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasketLoadData implements BasketLoadData {
  const _BasketLoadData({required this.referenceWeight, required this.count, required this.realWeight});
  factory _BasketLoadData.fromJson(Map<String, dynamic> json) => _$BasketLoadDataFromJson(json);

@override final  double referenceWeight;
@override final  int count;
@override final  double realWeight;

/// Create a copy of BasketLoadData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketLoadDataCopyWith<_BasketLoadData> get copyWith => __$BasketLoadDataCopyWithImpl<_BasketLoadData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasketLoadDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketLoadData&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.count, count) || other.count == count)&&(identical(other.realWeight, realWeight) || other.realWeight == realWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,referenceWeight,count,realWeight);

@override
String toString() {
  return 'BasketLoadData(referenceWeight: $referenceWeight, count: $count, realWeight: $realWeight)';
}


}

/// @nodoc
abstract mixin class _$BasketLoadDataCopyWith<$Res> implements $BasketLoadDataCopyWith<$Res> {
  factory _$BasketLoadDataCopyWith(_BasketLoadData value, $Res Function(_BasketLoadData) _then) = __$BasketLoadDataCopyWithImpl;
@override @useResult
$Res call({
 double referenceWeight, int count, double realWeight
});




}
/// @nodoc
class __$BasketLoadDataCopyWithImpl<$Res>
    implements _$BasketLoadDataCopyWith<$Res> {
  __$BasketLoadDataCopyWithImpl(this._self, this._then);

  final _BasketLoadData _self;
  final $Res Function(_BasketLoadData) _then;

/// Create a copy of BasketLoadData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? referenceWeight = null,Object? count = null,Object? realWeight = null,}) {
  return _then(_BasketLoadData(
referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,realWeight: null == realWeight ? _self.realWeight : realWeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
