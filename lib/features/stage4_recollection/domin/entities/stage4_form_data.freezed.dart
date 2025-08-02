// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage4_form_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stage4FormData {

 String get id; String get projectId; DateTime get date; List<ReturnedGaveras> get returnedGaveras; int get returnedBaskets; int get returnedPreservativesJars; int get returnedLimeJars;
/// Create a copy of Stage4FormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage4FormDataCopyWith<Stage4FormData> get copyWith => _$Stage4FormDataCopyWithImpl<Stage4FormData>(this as Stage4FormData, _$identity);

  /// Serializes this Stage4FormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage4FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.returnedGaveras, returnedGaveras)&&(identical(other.returnedBaskets, returnedBaskets) || other.returnedBaskets == returnedBaskets)&&(identical(other.returnedPreservativesJars, returnedPreservativesJars) || other.returnedPreservativesJars == returnedPreservativesJars)&&(identical(other.returnedLimeJars, returnedLimeJars) || other.returnedLimeJars == returnedLimeJars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,const DeepCollectionEquality().hash(returnedGaveras),returnedBaskets,returnedPreservativesJars,returnedLimeJars);

@override
String toString() {
  return 'Stage4FormData(id: $id, projectId: $projectId, date: $date, returnedGaveras: $returnedGaveras, returnedBaskets: $returnedBaskets, returnedPreservativesJars: $returnedPreservativesJars, returnedLimeJars: $returnedLimeJars)';
}


}

/// @nodoc
abstract mixin class $Stage4FormDataCopyWith<$Res>  {
  factory $Stage4FormDataCopyWith(Stage4FormData value, $Res Function(Stage4FormData) _then) = _$Stage4FormDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, DateTime date, List<ReturnedGaveras> returnedGaveras, int returnedBaskets, int returnedPreservativesJars, int returnedLimeJars
});




}
/// @nodoc
class _$Stage4FormDataCopyWithImpl<$Res>
    implements $Stage4FormDataCopyWith<$Res> {
  _$Stage4FormDataCopyWithImpl(this._self, this._then);

  final Stage4FormData _self;
  final $Res Function(Stage4FormData) _then;

/// Create a copy of Stage4FormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? returnedGaveras = null,Object? returnedBaskets = null,Object? returnedPreservativesJars = null,Object? returnedLimeJars = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,returnedGaveras: null == returnedGaveras ? _self.returnedGaveras : returnedGaveras // ignore: cast_nullable_to_non_nullable
as List<ReturnedGaveras>,returnedBaskets: null == returnedBaskets ? _self.returnedBaskets : returnedBaskets // ignore: cast_nullable_to_non_nullable
as int,returnedPreservativesJars: null == returnedPreservativesJars ? _self.returnedPreservativesJars : returnedPreservativesJars // ignore: cast_nullable_to_non_nullable
as int,returnedLimeJars: null == returnedLimeJars ? _self.returnedLimeJars : returnedLimeJars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage4FormData].
extension Stage4FormDataPatterns on Stage4FormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage4FormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage4FormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage4FormData value)  $default,){
final _that = this;
switch (_that) {
case _Stage4FormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage4FormData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage4FormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage4FormData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)  $default,) {final _that = this;
switch (_that) {
case _Stage4FormData():
return $default(_that.id,_that.projectId,_that.date,_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  DateTime date,  List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)?  $default,) {final _that = this;
switch (_that) {
case _Stage4FormData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage4FormData implements Stage4FormData {
  const _Stage4FormData({required this.id, required this.projectId, required this.date, required final  List<ReturnedGaveras> returnedGaveras, required this.returnedBaskets, required this.returnedPreservativesJars, required this.returnedLimeJars}): _returnedGaveras = returnedGaveras;
  factory _Stage4FormData.fromJson(Map<String, dynamic> json) => _$Stage4FormDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  DateTime date;
 final  List<ReturnedGaveras> _returnedGaveras;
@override List<ReturnedGaveras> get returnedGaveras {
  if (_returnedGaveras is EqualUnmodifiableListView) return _returnedGaveras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returnedGaveras);
}

@override final  int returnedBaskets;
@override final  int returnedPreservativesJars;
@override final  int returnedLimeJars;

/// Create a copy of Stage4FormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage4FormDataCopyWith<_Stage4FormData> get copyWith => __$Stage4FormDataCopyWithImpl<_Stage4FormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage4FormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage4FormData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._returnedGaveras, _returnedGaveras)&&(identical(other.returnedBaskets, returnedBaskets) || other.returnedBaskets == returnedBaskets)&&(identical(other.returnedPreservativesJars, returnedPreservativesJars) || other.returnedPreservativesJars == returnedPreservativesJars)&&(identical(other.returnedLimeJars, returnedLimeJars) || other.returnedLimeJars == returnedLimeJars));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,const DeepCollectionEquality().hash(_returnedGaveras),returnedBaskets,returnedPreservativesJars,returnedLimeJars);

@override
String toString() {
  return 'Stage4FormData(id: $id, projectId: $projectId, date: $date, returnedGaveras: $returnedGaveras, returnedBaskets: $returnedBaskets, returnedPreservativesJars: $returnedPreservativesJars, returnedLimeJars: $returnedLimeJars)';
}


}

/// @nodoc
abstract mixin class _$Stage4FormDataCopyWith<$Res> implements $Stage4FormDataCopyWith<$Res> {
  factory _$Stage4FormDataCopyWith(_Stage4FormData value, $Res Function(_Stage4FormData) _then) = __$Stage4FormDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, DateTime date, List<ReturnedGaveras> returnedGaveras, int returnedBaskets, int returnedPreservativesJars, int returnedLimeJars
});




}
/// @nodoc
class __$Stage4FormDataCopyWithImpl<$Res>
    implements _$Stage4FormDataCopyWith<$Res> {
  __$Stage4FormDataCopyWithImpl(this._self, this._then);

  final _Stage4FormData _self;
  final $Res Function(_Stage4FormData) _then;

/// Create a copy of Stage4FormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? returnedGaveras = null,Object? returnedBaskets = null,Object? returnedPreservativesJars = null,Object? returnedLimeJars = null,}) {
  return _then(_Stage4FormData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,returnedGaveras: null == returnedGaveras ? _self._returnedGaveras : returnedGaveras // ignore: cast_nullable_to_non_nullable
as List<ReturnedGaveras>,returnedBaskets: null == returnedBaskets ? _self.returnedBaskets : returnedBaskets // ignore: cast_nullable_to_non_nullable
as int,returnedPreservativesJars: null == returnedPreservativesJars ? _self.returnedPreservativesJars : returnedPreservativesJars // ignore: cast_nullable_to_non_nullable
as int,returnedLimeJars: null == returnedLimeJars ? _self.returnedLimeJars : returnedLimeJars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReturnedGaveras {

 int get quantity; double get referenceWeight;
/// Create a copy of ReturnedGaveras
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReturnedGaverasCopyWith<ReturnedGaveras> get copyWith => _$ReturnedGaverasCopyWithImpl<ReturnedGaveras>(this as ReturnedGaveras, _$identity);

  /// Serializes this ReturnedGaveras to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReturnedGaveras&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight);

@override
String toString() {
  return 'ReturnedGaveras(quantity: $quantity, referenceWeight: $referenceWeight)';
}


}

/// @nodoc
abstract mixin class $ReturnedGaverasCopyWith<$Res>  {
  factory $ReturnedGaverasCopyWith(ReturnedGaveras value, $Res Function(ReturnedGaveras) _then) = _$ReturnedGaverasCopyWithImpl;
@useResult
$Res call({
 int quantity, double referenceWeight
});




}
/// @nodoc
class _$ReturnedGaverasCopyWithImpl<$Res>
    implements $ReturnedGaverasCopyWith<$Res> {
  _$ReturnedGaverasCopyWithImpl(this._self, this._then);

  final ReturnedGaveras _self;
  final $Res Function(ReturnedGaveras) _then;

/// Create a copy of ReturnedGaveras
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quantity = null,Object? referenceWeight = null,}) {
  return _then(_self.copyWith(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReturnedGaveras].
extension ReturnedGaverasPatterns on ReturnedGaveras {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReturnedGaveras value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReturnedGaveras() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReturnedGaveras value)  $default,){
final _that = this;
switch (_that) {
case _ReturnedGaveras():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReturnedGaveras value)?  $default,){
final _that = this;
switch (_that) {
case _ReturnedGaveras() when $default != null:
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
case _ReturnedGaveras() when $default != null:
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
case _ReturnedGaveras():
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
case _ReturnedGaveras() when $default != null:
return $default(_that.quantity,_that.referenceWeight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReturnedGaveras implements ReturnedGaveras {
  const _ReturnedGaveras({required this.quantity, required this.referenceWeight});
  factory _ReturnedGaveras.fromJson(Map<String, dynamic> json) => _$ReturnedGaverasFromJson(json);

@override final  int quantity;
@override final  double referenceWeight;

/// Create a copy of ReturnedGaveras
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReturnedGaverasCopyWith<_ReturnedGaveras> get copyWith => __$ReturnedGaverasCopyWithImpl<_ReturnedGaveras>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReturnedGaverasToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReturnedGaveras&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.referenceWeight, referenceWeight) || other.referenceWeight == referenceWeight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quantity,referenceWeight);

@override
String toString() {
  return 'ReturnedGaveras(quantity: $quantity, referenceWeight: $referenceWeight)';
}


}

/// @nodoc
abstract mixin class _$ReturnedGaverasCopyWith<$Res> implements $ReturnedGaverasCopyWith<$Res> {
  factory _$ReturnedGaverasCopyWith(_ReturnedGaveras value, $Res Function(_ReturnedGaveras) _then) = __$ReturnedGaverasCopyWithImpl;
@override @useResult
$Res call({
 int quantity, double referenceWeight
});




}
/// @nodoc
class __$ReturnedGaverasCopyWithImpl<$Res>
    implements _$ReturnedGaverasCopyWith<$Res> {
  __$ReturnedGaverasCopyWithImpl(this._self, this._then);

  final _ReturnedGaveras _self;
  final $Res Function(_ReturnedGaveras) _then;

/// Create a copy of ReturnedGaveras
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quantity = null,Object? referenceWeight = null,}) {
  return _then(_ReturnedGaveras(
quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,referenceWeight: null == referenceWeight ? _self.referenceWeight : referenceWeight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
