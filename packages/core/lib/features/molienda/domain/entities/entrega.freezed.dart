// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entrega.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Entrega {

 String get id; String get moliendaId; String get produccionId;// referencia al Stage1FormData.id
 DateTime get fechaEntrega; String get qrToken;
/// Create a copy of Entrega
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntregaCopyWith<Entrega> get copyWith => _$EntregaCopyWithImpl<Entrega>(this as Entrega, _$identity);

  /// Serializes this Entrega to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Entrega&&(identical(other.id, id) || other.id == id)&&(identical(other.moliendaId, moliendaId) || other.moliendaId == moliendaId)&&(identical(other.produccionId, produccionId) || other.produccionId == produccionId)&&(identical(other.fechaEntrega, fechaEntrega) || other.fechaEntrega == fechaEntrega)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moliendaId,produccionId,fechaEntrega,qrToken);

@override
String toString() {
  return 'Entrega(id: $id, moliendaId: $moliendaId, produccionId: $produccionId, fechaEntrega: $fechaEntrega, qrToken: $qrToken)';
}


}

/// @nodoc
abstract mixin class $EntregaCopyWith<$Res>  {
  factory $EntregaCopyWith(Entrega value, $Res Function(Entrega) _then) = _$EntregaCopyWithImpl;
@useResult
$Res call({
 String id, String moliendaId, String produccionId, DateTime fechaEntrega, String qrToken
});




}
/// @nodoc
class _$EntregaCopyWithImpl<$Res>
    implements $EntregaCopyWith<$Res> {
  _$EntregaCopyWithImpl(this._self, this._then);

  final Entrega _self;
  final $Res Function(Entrega) _then;

/// Create a copy of Entrega
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moliendaId = null,Object? produccionId = null,Object? fechaEntrega = null,Object? qrToken = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moliendaId: null == moliendaId ? _self.moliendaId : moliendaId // ignore: cast_nullable_to_non_nullable
as String,produccionId: null == produccionId ? _self.produccionId : produccionId // ignore: cast_nullable_to_non_nullable
as String,fechaEntrega: null == fechaEntrega ? _self.fechaEntrega : fechaEntrega // ignore: cast_nullable_to_non_nullable
as DateTime,qrToken: null == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Entrega].
extension EntregaPatterns on Entrega {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Entrega value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Entrega() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Entrega value)  $default,){
final _that = this;
switch (_that) {
case _Entrega():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Entrega value)?  $default,){
final _that = this;
switch (_that) {
case _Entrega() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String moliendaId,  String produccionId,  DateTime fechaEntrega,  String qrToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Entrega() when $default != null:
return $default(_that.id,_that.moliendaId,_that.produccionId,_that.fechaEntrega,_that.qrToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String moliendaId,  String produccionId,  DateTime fechaEntrega,  String qrToken)  $default,) {final _that = this;
switch (_that) {
case _Entrega():
return $default(_that.id,_that.moliendaId,_that.produccionId,_that.fechaEntrega,_that.qrToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String moliendaId,  String produccionId,  DateTime fechaEntrega,  String qrToken)?  $default,) {final _that = this;
switch (_that) {
case _Entrega() when $default != null:
return $default(_that.id,_that.moliendaId,_that.produccionId,_that.fechaEntrega,_that.qrToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Entrega implements Entrega {
  const _Entrega({required this.id, required this.moliendaId, required this.produccionId, required this.fechaEntrega, required this.qrToken});
  factory _Entrega.fromJson(Map<String, dynamic> json) => _$EntregaFromJson(json);

@override final  String id;
@override final  String moliendaId;
@override final  String produccionId;
// referencia al Stage1FormData.id
@override final  DateTime fechaEntrega;
@override final  String qrToken;

/// Create a copy of Entrega
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntregaCopyWith<_Entrega> get copyWith => __$EntregaCopyWithImpl<_Entrega>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntregaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Entrega&&(identical(other.id, id) || other.id == id)&&(identical(other.moliendaId, moliendaId) || other.moliendaId == moliendaId)&&(identical(other.produccionId, produccionId) || other.produccionId == produccionId)&&(identical(other.fechaEntrega, fechaEntrega) || other.fechaEntrega == fechaEntrega)&&(identical(other.qrToken, qrToken) || other.qrToken == qrToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,moliendaId,produccionId,fechaEntrega,qrToken);

@override
String toString() {
  return 'Entrega(id: $id, moliendaId: $moliendaId, produccionId: $produccionId, fechaEntrega: $fechaEntrega, qrToken: $qrToken)';
}


}

/// @nodoc
abstract mixin class _$EntregaCopyWith<$Res> implements $EntregaCopyWith<$Res> {
  factory _$EntregaCopyWith(_Entrega value, $Res Function(_Entrega) _then) = __$EntregaCopyWithImpl;
@override @useResult
$Res call({
 String id, String moliendaId, String produccionId, DateTime fechaEntrega, String qrToken
});




}
/// @nodoc
class __$EntregaCopyWithImpl<$Res>
    implements _$EntregaCopyWith<$Res> {
  __$EntregaCopyWithImpl(this._self, this._then);

  final _Entrega _self;
  final $Res Function(_Entrega) _then;

/// Create a copy of Entrega
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moliendaId = null,Object? produccionId = null,Object? fechaEntrega = null,Object? qrToken = null,}) {
  return _then(_Entrega(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moliendaId: null == moliendaId ? _self.moliendaId : moliendaId // ignore: cast_nullable_to_non_nullable
as String,produccionId: null == produccionId ? _self.produccionId : produccionId // ignore: cast_nullable_to_non_nullable
as String,fechaEntrega: null == fechaEntrega ? _self.fechaEntrega : fechaEntrega // ignore: cast_nullable_to_non_nullable
as DateTime,qrToken: null == qrToken ? _self.qrToken : qrToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
