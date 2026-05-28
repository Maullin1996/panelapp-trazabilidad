// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage52_record_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stage52RecordData {

 String get id; String get projectId; double get gaveraWeight;// de Stage1
 double get panelaWeight;// peso real de panela
 int get unitCount;// unidades de panela (ej. número de sacos)
 BasketQuality get quality;// reuseamos el enum de Stage3
 String get photoPath; DateTime get date;
/// Create a copy of Stage52RecordData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage52RecordDataCopyWith<Stage52RecordData> get copyWith => _$Stage52RecordDataCopyWithImpl<Stage52RecordData>(this as Stage52RecordData, _$identity);

  /// Serializes this Stage52RecordData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage52RecordData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.gaveraWeight, gaveraWeight) || other.gaveraWeight == gaveraWeight)&&(identical(other.panelaWeight, panelaWeight) || other.panelaWeight == panelaWeight)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,gaveraWeight,panelaWeight,unitCount,quality,photoPath,date);

@override
String toString() {
  return 'Stage52RecordData(id: $id, projectId: $projectId, gaveraWeight: $gaveraWeight, panelaWeight: $panelaWeight, unitCount: $unitCount, quality: $quality, photoPath: $photoPath, date: $date)';
}


}

/// @nodoc
abstract mixin class $Stage52RecordDataCopyWith<$Res>  {
  factory $Stage52RecordDataCopyWith(Stage52RecordData value, $Res Function(Stage52RecordData) _then) = _$Stage52RecordDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, double gaveraWeight, double panelaWeight, int unitCount, BasketQuality quality, String photoPath, DateTime date
});




}
/// @nodoc
class _$Stage52RecordDataCopyWithImpl<$Res>
    implements $Stage52RecordDataCopyWith<$Res> {
  _$Stage52RecordDataCopyWithImpl(this._self, this._then);

  final Stage52RecordData _self;
  final $Res Function(Stage52RecordData) _then;

/// Create a copy of Stage52RecordData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? gaveraWeight = null,Object? panelaWeight = null,Object? unitCount = null,Object? quality = null,Object? photoPath = null,Object? date = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,gaveraWeight: null == gaveraWeight ? _self.gaveraWeight : gaveraWeight // ignore: cast_nullable_to_non_nullable
as double,panelaWeight: null == panelaWeight ? _self.panelaWeight : panelaWeight // ignore: cast_nullable_to_non_nullable
as double,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage52RecordData].
extension Stage52RecordDataPatterns on Stage52RecordData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage52RecordData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage52RecordData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage52RecordData value)  $default,){
final _that = this;
switch (_that) {
case _Stage52RecordData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage52RecordData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage52RecordData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  double gaveraWeight,  double panelaWeight,  int unitCount,  BasketQuality quality,  String photoPath,  DateTime date)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage52RecordData() when $default != null:
return $default(_that.id,_that.projectId,_that.gaveraWeight,_that.panelaWeight,_that.unitCount,_that.quality,_that.photoPath,_that.date);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  double gaveraWeight,  double panelaWeight,  int unitCount,  BasketQuality quality,  String photoPath,  DateTime date)  $default,) {final _that = this;
switch (_that) {
case _Stage52RecordData():
return $default(_that.id,_that.projectId,_that.gaveraWeight,_that.panelaWeight,_that.unitCount,_that.quality,_that.photoPath,_that.date);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  double gaveraWeight,  double panelaWeight,  int unitCount,  BasketQuality quality,  String photoPath,  DateTime date)?  $default,) {final _that = this;
switch (_that) {
case _Stage52RecordData() when $default != null:
return $default(_that.id,_that.projectId,_that.gaveraWeight,_that.panelaWeight,_that.unitCount,_that.quality,_that.photoPath,_that.date);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage52RecordData implements Stage52RecordData {
  const _Stage52RecordData({required this.id, required this.projectId, required this.gaveraWeight, required this.panelaWeight, required this.unitCount, required this.quality, required this.photoPath, required this.date});
  factory _Stage52RecordData.fromJson(Map<String, dynamic> json) => _$Stage52RecordDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  double gaveraWeight;
// de Stage1
@override final  double panelaWeight;
// peso real de panela
@override final  int unitCount;
// unidades de panela (ej. número de sacos)
@override final  BasketQuality quality;
// reuseamos el enum de Stage3
@override final  String photoPath;
@override final  DateTime date;

/// Create a copy of Stage52RecordData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage52RecordDataCopyWith<_Stage52RecordData> get copyWith => __$Stage52RecordDataCopyWithImpl<_Stage52RecordData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage52RecordDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage52RecordData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.gaveraWeight, gaveraWeight) || other.gaveraWeight == gaveraWeight)&&(identical(other.panelaWeight, panelaWeight) || other.panelaWeight == panelaWeight)&&(identical(other.unitCount, unitCount) || other.unitCount == unitCount)&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.date, date) || other.date == date));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,gaveraWeight,panelaWeight,unitCount,quality,photoPath,date);

@override
String toString() {
  return 'Stage52RecordData(id: $id, projectId: $projectId, gaveraWeight: $gaveraWeight, panelaWeight: $panelaWeight, unitCount: $unitCount, quality: $quality, photoPath: $photoPath, date: $date)';
}


}

/// @nodoc
abstract mixin class _$Stage52RecordDataCopyWith<$Res> implements $Stage52RecordDataCopyWith<$Res> {
  factory _$Stage52RecordDataCopyWith(_Stage52RecordData value, $Res Function(_Stage52RecordData) _then) = __$Stage52RecordDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, double gaveraWeight, double panelaWeight, int unitCount, BasketQuality quality, String photoPath, DateTime date
});




}
/// @nodoc
class __$Stage52RecordDataCopyWithImpl<$Res>
    implements _$Stage52RecordDataCopyWith<$Res> {
  __$Stage52RecordDataCopyWithImpl(this._self, this._then);

  final _Stage52RecordData _self;
  final $Res Function(_Stage52RecordData) _then;

/// Create a copy of Stage52RecordData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? gaveraWeight = null,Object? panelaWeight = null,Object? unitCount = null,Object? quality = null,Object? photoPath = null,Object? date = null,}) {
  return _then(_Stage52RecordData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,gaveraWeight: null == gaveraWeight ? _self.gaveraWeight : gaveraWeight // ignore: cast_nullable_to_non_nullable
as double,panelaWeight: null == panelaWeight ? _self.panelaWeight : panelaWeight // ignore: cast_nullable_to_non_nullable
as double,unitCount: null == unitCount ? _self.unitCount : unitCount // ignore: cast_nullable_to_non_nullable
as int,quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
