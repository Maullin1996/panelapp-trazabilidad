// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'molienda.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Molienda {

 String get id; String get nombre; String get telefono; DateTime get creadoEn;
/// Create a copy of Molienda
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MoliendaCopyWith<Molienda> get copyWith => _$MoliendaCopyWithImpl<Molienda>(this as Molienda, _$identity);

  /// Serializes this Molienda to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Molienda&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.creadoEn, creadoEn) || other.creadoEn == creadoEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,telefono,creadoEn);

@override
String toString() {
  return 'Molienda(id: $id, nombre: $nombre, telefono: $telefono, creadoEn: $creadoEn)';
}


}

/// @nodoc
abstract mixin class $MoliendaCopyWith<$Res>  {
  factory $MoliendaCopyWith(Molienda value, $Res Function(Molienda) _then) = _$MoliendaCopyWithImpl;
@useResult
$Res call({
 String id, String nombre, String telefono, DateTime creadoEn
});




}
/// @nodoc
class _$MoliendaCopyWithImpl<$Res>
    implements $MoliendaCopyWith<$Res> {
  _$MoliendaCopyWithImpl(this._self, this._then);

  final Molienda _self;
  final $Res Function(Molienda) _then;

/// Create a copy of Molienda
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nombre = null,Object? telefono = null,Object? creadoEn = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,telefono: null == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String,creadoEn: null == creadoEn ? _self.creadoEn : creadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Molienda].
extension MoliendaPatterns on Molienda {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Molienda value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Molienda() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Molienda value)  $default,){
final _that = this;
switch (_that) {
case _Molienda():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Molienda value)?  $default,){
final _that = this;
switch (_that) {
case _Molienda() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nombre,  String telefono,  DateTime creadoEn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Molienda() when $default != null:
return $default(_that.id,_that.nombre,_that.telefono,_that.creadoEn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nombre,  String telefono,  DateTime creadoEn)  $default,) {final _that = this;
switch (_that) {
case _Molienda():
return $default(_that.id,_that.nombre,_that.telefono,_that.creadoEn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nombre,  String telefono,  DateTime creadoEn)?  $default,) {final _that = this;
switch (_that) {
case _Molienda() when $default != null:
return $default(_that.id,_that.nombre,_that.telefono,_that.creadoEn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Molienda implements Molienda {
  const _Molienda({required this.id, required this.nombre, required this.telefono, required this.creadoEn});
  factory _Molienda.fromJson(Map<String, dynamic> json) => _$MoliendaFromJson(json);

@override final  String id;
@override final  String nombre;
@override final  String telefono;
@override final  DateTime creadoEn;

/// Create a copy of Molienda
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MoliendaCopyWith<_Molienda> get copyWith => __$MoliendaCopyWithImpl<_Molienda>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MoliendaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Molienda&&(identical(other.id, id) || other.id == id)&&(identical(other.nombre, nombre) || other.nombre == nombre)&&(identical(other.telefono, telefono) || other.telefono == telefono)&&(identical(other.creadoEn, creadoEn) || other.creadoEn == creadoEn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nombre,telefono,creadoEn);

@override
String toString() {
  return 'Molienda(id: $id, nombre: $nombre, telefono: $telefono, creadoEn: $creadoEn)';
}


}

/// @nodoc
abstract mixin class _$MoliendaCopyWith<$Res> implements $MoliendaCopyWith<$Res> {
  factory _$MoliendaCopyWith(_Molienda value, $Res Function(_Molienda) _then) = __$MoliendaCopyWithImpl;
@override @useResult
$Res call({
 String id, String nombre, String telefono, DateTime creadoEn
});




}
/// @nodoc
class __$MoliendaCopyWithImpl<$Res>
    implements _$MoliendaCopyWith<$Res> {
  __$MoliendaCopyWithImpl(this._self, this._then);

  final _Molienda _self;
  final $Res Function(_Molienda) _then;

/// Create a copy of Molienda
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nombre = null,Object? telefono = null,Object? creadoEn = null,}) {
  return _then(_Molienda(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nombre: null == nombre ? _self.nombre : nombre // ignore: cast_nullable_to_non_nullable
as String,telefono: null == telefono ? _self.telefono : telefono // ignore: cast_nullable_to_non_nullable
as String,creadoEn: null == creadoEn ? _self.creadoEn : creadoEn // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
