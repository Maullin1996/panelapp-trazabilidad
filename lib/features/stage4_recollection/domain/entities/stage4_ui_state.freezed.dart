// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage4_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Stage4UiState {

 List<ReturnedGaveras> get returnedGaveras; int get returnedBaskets; int get returnedPreservativesJars; int get returnedLimeJars;
/// Create a copy of Stage4UiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage4UiStateCopyWith<Stage4UiState> get copyWith => _$Stage4UiStateCopyWithImpl<Stage4UiState>(this as Stage4UiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage4UiState&&const DeepCollectionEquality().equals(other.returnedGaveras, returnedGaveras)&&(identical(other.returnedBaskets, returnedBaskets) || other.returnedBaskets == returnedBaskets)&&(identical(other.returnedPreservativesJars, returnedPreservativesJars) || other.returnedPreservativesJars == returnedPreservativesJars)&&(identical(other.returnedLimeJars, returnedLimeJars) || other.returnedLimeJars == returnedLimeJars));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(returnedGaveras),returnedBaskets,returnedPreservativesJars,returnedLimeJars);

@override
String toString() {
  return 'Stage4UiState(returnedGaveras: $returnedGaveras, returnedBaskets: $returnedBaskets, returnedPreservativesJars: $returnedPreservativesJars, returnedLimeJars: $returnedLimeJars)';
}


}

/// @nodoc
abstract mixin class $Stage4UiStateCopyWith<$Res>  {
  factory $Stage4UiStateCopyWith(Stage4UiState value, $Res Function(Stage4UiState) _then) = _$Stage4UiStateCopyWithImpl;
@useResult
$Res call({
 List<ReturnedGaveras> returnedGaveras, int returnedBaskets, int returnedPreservativesJars, int returnedLimeJars
});




}
/// @nodoc
class _$Stage4UiStateCopyWithImpl<$Res>
    implements $Stage4UiStateCopyWith<$Res> {
  _$Stage4UiStateCopyWithImpl(this._self, this._then);

  final Stage4UiState _self;
  final $Res Function(Stage4UiState) _then;

/// Create a copy of Stage4UiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? returnedGaveras = null,Object? returnedBaskets = null,Object? returnedPreservativesJars = null,Object? returnedLimeJars = null,}) {
  return _then(_self.copyWith(
returnedGaveras: null == returnedGaveras ? _self.returnedGaveras : returnedGaveras // ignore: cast_nullable_to_non_nullable
as List<ReturnedGaveras>,returnedBaskets: null == returnedBaskets ? _self.returnedBaskets : returnedBaskets // ignore: cast_nullable_to_non_nullable
as int,returnedPreservativesJars: null == returnedPreservativesJars ? _self.returnedPreservativesJars : returnedPreservativesJars // ignore: cast_nullable_to_non_nullable
as int,returnedLimeJars: null == returnedLimeJars ? _self.returnedLimeJars : returnedLimeJars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage4UiState].
extension Stage4UiStatePatterns on Stage4UiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage4UiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage4UiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage4UiState value)  $default,){
final _that = this;
switch (_that) {
case _Stage4UiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage4UiState value)?  $default,){
final _that = this;
switch (_that) {
case _Stage4UiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage4UiState() when $default != null:
return $default(_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)  $default,) {final _that = this;
switch (_that) {
case _Stage4UiState():
return $default(_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReturnedGaveras> returnedGaveras,  int returnedBaskets,  int returnedPreservativesJars,  int returnedLimeJars)?  $default,) {final _that = this;
switch (_that) {
case _Stage4UiState() when $default != null:
return $default(_that.returnedGaveras,_that.returnedBaskets,_that.returnedPreservativesJars,_that.returnedLimeJars);case _:
  return null;

}
}

}

/// @nodoc


class _Stage4UiState implements Stage4UiState {
  const _Stage4UiState({required final  List<ReturnedGaveras> returnedGaveras, required this.returnedBaskets, required this.returnedPreservativesJars, required this.returnedLimeJars}): _returnedGaveras = returnedGaveras;
  

 final  List<ReturnedGaveras> _returnedGaveras;
@override List<ReturnedGaveras> get returnedGaveras {
  if (_returnedGaveras is EqualUnmodifiableListView) return _returnedGaveras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_returnedGaveras);
}

@override final  int returnedBaskets;
@override final  int returnedPreservativesJars;
@override final  int returnedLimeJars;

/// Create a copy of Stage4UiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage4UiStateCopyWith<_Stage4UiState> get copyWith => __$Stage4UiStateCopyWithImpl<_Stage4UiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage4UiState&&const DeepCollectionEquality().equals(other._returnedGaveras, _returnedGaveras)&&(identical(other.returnedBaskets, returnedBaskets) || other.returnedBaskets == returnedBaskets)&&(identical(other.returnedPreservativesJars, returnedPreservativesJars) || other.returnedPreservativesJars == returnedPreservativesJars)&&(identical(other.returnedLimeJars, returnedLimeJars) || other.returnedLimeJars == returnedLimeJars));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_returnedGaveras),returnedBaskets,returnedPreservativesJars,returnedLimeJars);

@override
String toString() {
  return 'Stage4UiState(returnedGaveras: $returnedGaveras, returnedBaskets: $returnedBaskets, returnedPreservativesJars: $returnedPreservativesJars, returnedLimeJars: $returnedLimeJars)';
}


}

/// @nodoc
abstract mixin class _$Stage4UiStateCopyWith<$Res> implements $Stage4UiStateCopyWith<$Res> {
  factory _$Stage4UiStateCopyWith(_Stage4UiState value, $Res Function(_Stage4UiState) _then) = __$Stage4UiStateCopyWithImpl;
@override @useResult
$Res call({
 List<ReturnedGaveras> returnedGaveras, int returnedBaskets, int returnedPreservativesJars, int returnedLimeJars
});




}
/// @nodoc
class __$Stage4UiStateCopyWithImpl<$Res>
    implements _$Stage4UiStateCopyWith<$Res> {
  __$Stage4UiStateCopyWithImpl(this._self, this._then);

  final _Stage4UiState _self;
  final $Res Function(_Stage4UiState) _then;

/// Create a copy of Stage4UiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? returnedGaveras = null,Object? returnedBaskets = null,Object? returnedPreservativesJars = null,Object? returnedLimeJars = null,}) {
  return _then(_Stage4UiState(
returnedGaveras: null == returnedGaveras ? _self._returnedGaveras : returnedGaveras // ignore: cast_nullable_to_non_nullable
as List<ReturnedGaveras>,returnedBaskets: null == returnedBaskets ? _self.returnedBaskets : returnedBaskets // ignore: cast_nullable_to_non_nullable
as int,returnedPreservativesJars: null == returnedPreservativesJars ? _self.returnedPreservativesJars : returnedPreservativesJars // ignore: cast_nullable_to_non_nullable
as int,returnedLimeJars: null == returnedLimeJars ? _self.returnedLimeJars : returnedLimeJars // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
