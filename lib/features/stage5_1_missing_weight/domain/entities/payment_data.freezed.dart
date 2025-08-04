// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentData {

 String get id; String get projectId; DateTime get date; double get amount;
/// Create a copy of PaymentData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentDataCopyWith<PaymentData> get copyWith => _$PaymentDataCopyWithImpl<PaymentData>(this as PaymentData, _$identity);

  /// Serializes this PaymentData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,amount);

@override
String toString() {
  return 'PaymentData(id: $id, projectId: $projectId, date: $date, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $PaymentDataCopyWith<$Res>  {
  factory $PaymentDataCopyWith(PaymentData value, $Res Function(PaymentData) _then) = _$PaymentDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, DateTime date, double amount
});




}
/// @nodoc
class _$PaymentDataCopyWithImpl<$Res>
    implements $PaymentDataCopyWith<$Res> {
  _$PaymentDataCopyWithImpl(this._self, this._then);

  final PaymentData _self;
  final $Res Function(PaymentData) _then;

/// Create a copy of PaymentData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? amount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentData].
extension PaymentDataPatterns on PaymentData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentData value)  $default,){
final _that = this;
switch (_that) {
case _PaymentData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentData value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  double amount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  double amount)  $default,) {final _that = this;
switch (_that) {
case _PaymentData():
return $default(_that.id,_that.projectId,_that.date,_that.amount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  DateTime date,  double amount)?  $default,) {final _that = this;
switch (_that) {
case _PaymentData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.amount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentData implements PaymentData {
  const _PaymentData({required this.id, required this.projectId, required this.date, required this.amount});
  factory _PaymentData.fromJson(Map<String, dynamic> json) => _$PaymentDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  DateTime date;
@override final  double amount;

/// Create a copy of PaymentData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentDataCopyWith<_PaymentData> get copyWith => __$PaymentDataCopyWithImpl<_PaymentData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,amount);

@override
String toString() {
  return 'PaymentData(id: $id, projectId: $projectId, date: $date, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$PaymentDataCopyWith<$Res> implements $PaymentDataCopyWith<$Res> {
  factory _$PaymentDataCopyWith(_PaymentData value, $Res Function(_PaymentData) _then) = __$PaymentDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, DateTime date, double amount
});




}
/// @nodoc
class __$PaymentDataCopyWithImpl<$Res>
    implements _$PaymentDataCopyWith<$Res> {
  __$PaymentDataCopyWithImpl(this._self, this._then);

  final _PaymentData _self;
  final $Res Function(_PaymentData) _then;

/// Create a copy of PaymentData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? amount = null,}) {
  return _then(_PaymentData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
