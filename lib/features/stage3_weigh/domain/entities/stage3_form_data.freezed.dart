// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage3_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BasketWeighData {

 String get id; int get sequence; double get referenceWeight; double get realWeight; BasketQuality get quality; String get photoPath;
/// Create a copy of BasketWeighData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketWeighDataCopyWith<BasketWeighData> get copyWith => _$BasketWeighDataCopyWithImpl<BasketWeighData>(this as BasketWeighData, _$identity);

  /// Serializes this BasketWeighData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketWeighData&&(identical(other.id, id) || other.id == id)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.realWeight, realWeight) || other.realWeight == realWeight)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sequence,referenceWeight,realWeight,quality,photoPath);

@override
String toString() {
  return 'BasketWeighData(id: $id, sequence: $sequence, referenceWeight: $referenceWeight, realWeight: $realWeight, quality: $quality, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class $BasketWeighDataCopyWith<$Res>  {
  factory $BasketWeighDataCopyWith(BasketWeighData value, $Res Function(BasketWeighData) _then) = _$BasketWeighDataCopyWithImpl;
@useResult
$Res call({
 String id, int sequence, double referenceWeight, double realWeight, BasketQuality quality, String photoPath
});




}
/// @nodoc
class _$BasketWeighDataCopyWithImpl<$Res>
    implements $BasketWeighDataCopyWith<$Res> {
  _$BasketWeighDataCopyWithImpl(this._self, this._then);

  final BasketWeighData _self;
  final $Res Function(BasketWeighData) _then;

/// Create a copy of BasketWeighData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sequence = null,Object? referenceWeight = null,Object? realWeight = null,Object? quality = null,Object? photoPath = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,realWeight: null == realWeight ? _self.realWeight : realWeight // ignore: cast_nullable_to_non_nullable
as double,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketWeighData].
extension BasketWeighDataPatterns on BasketWeighData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketWeighData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketWeighData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketWeighData value)  $default,){
final _that = this;
switch (_that) {
case _BasketWeighData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketWeighData value)?  $default,){
final _that = this;
switch (_that) {
case _BasketWeighData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int sequence,  double referenceWeight,  double realWeight,  BasketQuality quality,  String photoPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketWeighData() when $default != null:
return $default(_that.id,_that.sequence,_that.referenceWeight,_that.realWeight,_that.quality,_that.photoPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int sequence,  double referenceWeight,  double realWeight,  BasketQuality quality,  String photoPath)  $default,) {final _that = this;
switch (_that) {
case _BasketWeighData():
return $default(_that.id,_that.sequence,_that.referenceWeight,_that.realWeight,_that.quality,_that.photoPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int sequence,  double referenceWeight,  double realWeight,  BasketQuality quality,  String photoPath)?  $default,) {final _that = this;
switch (_that) {
case _BasketWeighData() when $default != null:
return $default(_that.id,_that.sequence,_that.referenceWeight,_that.realWeight,_that.quality,_that.photoPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasketWeighData implements BasketWeighData {
  const _BasketWeighData({required this.id, required this.sequence, required this.referenceWeight, required this.realWeight, required this.quality, required this.photoPath});
  factory _BasketWeighData.fromJson(Map<String, dynamic> json) => _$BasketWeighDataFromJson(json);

@override final  String id;
@override final  int sequence;
@override final  double referenceWeight;
@override final  double realWeight;
@override final  BasketQuality quality;
@override final  String photoPath;

/// Create a copy of BasketWeighData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketWeighDataCopyWith<_BasketWeighData> get copyWith => __$BasketWeighDataCopyWithImpl<_BasketWeighData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasketWeighDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketWeighData&&(identical(other.id, id) || other.id == id)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight)&&(identical(other.realWeight, realWeight) || other.realWeight == realWeight)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sequence,referenceWeight,realWeight,quality,photoPath);

@override
String toString() {
  return 'BasketWeighData(id: $id, sequence: $sequence, referenceWeight: $referenceWeight, realWeight: $realWeight, quality: $quality, photoPath: $photoPath)';
}


}

/// @nodoc
abstract mixin class _$BasketWeighDataCopyWith<$Res> implements $BasketWeighDataCopyWith<$Res> {
  factory _$BasketWeighDataCopyWith(_BasketWeighData value, $Res Function(_BasketWeighData) _then) = __$BasketWeighDataCopyWithImpl;
@override @useResult
$Res call({
 String id, int sequence, double referenceWeight, double realWeight, BasketQuality quality, String photoPath
});




}
/// @nodoc
class __$BasketWeighDataCopyWithImpl<$Res>
    implements _$BasketWeighDataCopyWith<$Res> {
  __$BasketWeighDataCopyWithImpl(this._self, this._then);

  final _BasketWeighData _self;
  final $Res Function(_BasketWeighData) _then;

/// Create a copy of BasketWeighData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sequence = null,Object? referenceWeight = null,Object? realWeight = null,Object? quality = null,Object? photoPath = null,}) {
  return _then(_BasketWeighData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,realWeight: null == realWeight ? _self.realWeight : realWeight // ignore: cast_nullable_to_non_nullable
as double,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Stage3FormData {

 String get id; String get projectId; String get stage2LoadId; DateTime get date; List<BasketWeighData> get baskets;
/// Create a copy of Stage3FormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage3FormDataCopyWith<Stage3FormData> get copyWith => _$Stage3FormDataCopyWithImpl<Stage3FormData>(this as Stage3FormData, _$identity);

  /// Serializes this Stage3FormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage3FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.stage2LoadId, stage2LoadId) || other.stage2LoadId == stage2LoadId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.baskets, baskets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,stage2LoadId,date,const DeepCollectionEquality().hash(baskets));

@override
String toString() {
  return 'Stage3FormData(id: $id, projectId: $projectId, stage2LoadId: $stage2LoadId, date: $date, baskets: $baskets)';
}


}

/// @nodoc
abstract mixin class $Stage3FormDataCopyWith<$Res>  {
  factory $Stage3FormDataCopyWith(Stage3FormData value, $Res Function(Stage3FormData) _then) = _$Stage3FormDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String stage2LoadId, DateTime date, List<BasketWeighData> baskets
});




}
/// @nodoc
class _$Stage3FormDataCopyWithImpl<$Res>
    implements $Stage3FormDataCopyWith<$Res> {
  _$Stage3FormDataCopyWithImpl(this._self, this._then);

  final Stage3FormData _self;
  final $Res Function(Stage3FormData) _then;

/// Create a copy of Stage3FormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? stage2LoadId = null,Object? date = null,Object? baskets = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,stage2LoadId: null == stage2LoadId ? _self.stage2LoadId : stage2LoadId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,baskets: null == baskets ? _self.baskets : baskets // ignore: cast_nullable_to_non_nullable
as List<BasketWeighData>,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage3FormData].
extension Stage3FormDataPatterns on Stage3FormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage3FormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage3FormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage3FormData value)  $default,){
final _that = this;
switch (_that) {
case _Stage3FormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage3FormData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage3FormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String stage2LoadId,  DateTime date,  List<BasketWeighData> baskets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage3FormData() when $default != null:
return $default(_that.id,_that.projectId,_that.stage2LoadId,_that.date,_that.baskets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String stage2LoadId,  DateTime date,  List<BasketWeighData> baskets)  $default,) {final _that = this;
switch (_that) {
case _Stage3FormData():
return $default(_that.id,_that.projectId,_that.stage2LoadId,_that.date,_that.baskets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String stage2LoadId,  DateTime date,  List<BasketWeighData> baskets)?  $default,) {final _that = this;
switch (_that) {
case _Stage3FormData() when $default != null:
return $default(_that.id,_that.projectId,_that.stage2LoadId,_that.date,_that.baskets);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage3FormData implements Stage3FormData {
  const _Stage3FormData({required this.id, required this.projectId, required this.stage2LoadId, required this.date, required final  List<BasketWeighData> baskets}): _baskets = baskets;
  factory _Stage3FormData.fromJson(Map<String, dynamic> json) => _$Stage3FormDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String stage2LoadId;
@override final  DateTime date;
 final  List<BasketWeighData> _baskets;
@override List<BasketWeighData> get baskets {
  if (_baskets is EqualUnmodifiableListView) return _baskets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_baskets);
}


/// Create a copy of Stage3FormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage3FormDataCopyWith<_Stage3FormData> get copyWith => __$Stage3FormDataCopyWithImpl<_Stage3FormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage3FormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage3FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.stage2LoadId, stage2LoadId) || other.stage2LoadId == stage2LoadId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._baskets, _baskets));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,stage2LoadId,date,const DeepCollectionEquality().hash(_baskets));

@override
String toString() {
  return 'Stage3FormData(id: $id, projectId: $projectId, stage2LoadId: $stage2LoadId, date: $date, baskets: $baskets)';
}


}

/// @nodoc
abstract mixin class _$Stage3FormDataCopyWith<$Res> implements $Stage3FormDataCopyWith<$Res> {
  factory _$Stage3FormDataCopyWith(_Stage3FormData value, $Res Function(_Stage3FormData) _then) = __$Stage3FormDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String stage2LoadId, DateTime date, List<BasketWeighData> baskets
});




}
/// @nodoc
class __$Stage3FormDataCopyWithImpl<$Res>
    implements _$Stage3FormDataCopyWith<$Res> {
  __$Stage3FormDataCopyWithImpl(this._self, this._then);

  final _Stage3FormData _self;
  final $Res Function(_Stage3FormData) _then;

/// Create a copy of Stage3FormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? stage2LoadId = null,Object? date = null,Object? baskets = null,}) {
  return _then(_Stage3FormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,stage2LoadId: null == stage2LoadId ? _self.stage2LoadId : stage2LoadId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,baskets: null == baskets ? _self._baskets : baskets // ignore: cast_nullable_to_non_nullable
as List<BasketWeighData>,
  ));
}


}

// dart format on
