// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage5_price_form.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stage5PriceFormData {

 String get id; String get projectId; DateTime get date; double get pricePerKilo; double get installment;
/// Create a copy of Stage5PriceFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage5PriceFormDataCopyWith<Stage5PriceFormData> get copyWith => _$Stage5PriceFormDataCopyWithImpl<Stage5PriceFormData>(this as Stage5PriceFormData, _$identity);

  /// Serializes this Stage5PriceFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage5PriceFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.pricePerKilo, pricePerKilo) || other.pricePerKilo == pricePerKilo)&&(identical(other.installment, installment) || other.installment == installment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,pricePerKilo,installment);

@override
String toString() {
  return 'Stage5PriceFormData(id: $id, projectId: $projectId, date: $date, pricePerKilo: $pricePerKilo, installment: $installment)';
}


}

/// @nodoc
abstract mixin class $Stage5PriceFormDataCopyWith<$Res>  {
  factory $Stage5PriceFormDataCopyWith(Stage5PriceFormData value, $Res Function(Stage5PriceFormData) _then) = _$Stage5PriceFormDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, DateTime date, double pricePerKilo, double installment
});




}
/// @nodoc
class _$Stage5PriceFormDataCopyWithImpl<$Res>
    implements $Stage5PriceFormDataCopyWith<$Res> {
  _$Stage5PriceFormDataCopyWithImpl(this._self, this._then);

  final Stage5PriceFormData _self;
  final $Res Function(Stage5PriceFormData) _then;

/// Create a copy of Stage5PriceFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? pricePerKilo = null,Object? installment = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pricePerKilo: null == pricePerKilo ? _self.pricePerKilo : pricePerKilo // ignore: cast_nullable_to_non_nullable
as double,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage5PriceFormData].
extension Stage5PriceFormDataPatterns on Stage5PriceFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage5PriceFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage5PriceFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage5PriceFormData value)  $default,){
final _that = this;
switch (_that) {
case _Stage5PriceFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage5PriceFormData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage5PriceFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  double pricePerKilo,  double installment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage5PriceFormData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.pricePerKilo,_that.installment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  double pricePerKilo,  double installment)  $default,) {final _that = this;
switch (_that) {
case _Stage5PriceFormData():
return $default(_that.id,_that.projectId,_that.date,_that.pricePerKilo,_that.installment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  DateTime date,  double pricePerKilo,  double installment)?  $default,) {final _that = this;
switch (_that) {
case _Stage5PriceFormData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.pricePerKilo,_that.installment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage5PriceFormData implements Stage5PriceFormData {
  const _Stage5PriceFormData({required this.id, required this.projectId, required this.date, this.pricePerKilo = 0, this.installment = 0});
  factory _Stage5PriceFormData.fromJson(Map<String, dynamic> json) => _$Stage5PriceFormDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  DateTime date;
@override@JsonKey() final  double pricePerKilo;
@override@JsonKey() final  double installment;

/// Create a copy of Stage5PriceFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage5PriceFormDataCopyWith<_Stage5PriceFormData> get copyWith => __$Stage5PriceFormDataCopyWithImpl<_Stage5PriceFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage5PriceFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage5PriceFormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.pricePerKilo, pricePerKilo) || other.pricePerKilo == pricePerKilo)&&(identical(other.installment, installment) || other.installment == installment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,pricePerKilo,installment);

@override
String toString() {
  return 'Stage5PriceFormData(id: $id, projectId: $projectId, date: $date, pricePerKilo: $pricePerKilo, installment: $installment)';
}


}

/// @nodoc
abstract mixin class _$Stage5PriceFormDataCopyWith<$Res> implements $Stage5PriceFormDataCopyWith<$Res> {
  factory _$Stage5PriceFormDataCopyWith(_Stage5PriceFormData value, $Res Function(_Stage5PriceFormData) _then) = __$Stage5PriceFormDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, DateTime date, double pricePerKilo, double installment
});




}
/// @nodoc
class __$Stage5PriceFormDataCopyWithImpl<$Res>
    implements _$Stage5PriceFormDataCopyWith<$Res> {
  __$Stage5PriceFormDataCopyWithImpl(this._self, this._then);

  final _Stage5PriceFormData _self;
  final $Res Function(_Stage5PriceFormData) _then;

/// Create a copy of Stage5PriceFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? pricePerKilo = null,Object? installment = null,}) {
  return _then(_Stage5PriceFormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,pricePerKilo: null == pricePerKilo ? _self.pricePerKilo : pricePerKilo // ignore: cast_nullable_to_non_nullable
as double,installment: null == installment ? _self.installment : installment // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
