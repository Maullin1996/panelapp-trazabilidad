// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stage5_invoice_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Stage5InvoiceData {

 String get id; String get projectId; DateTime get date; List<InvoiceQualityLine> get lines;
/// Create a copy of Stage5InvoiceData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Stage5InvoiceDataCopyWith<Stage5InvoiceData> get copyWith => _$Stage5InvoiceDataCopyWithImpl<Stage5InvoiceData>(this as Stage5InvoiceData, _$identity);

  /// Serializes this Stage5InvoiceData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stage5InvoiceData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.lines, lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'Stage5InvoiceData(id: $id, projectId: $projectId, date: $date, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $Stage5InvoiceDataCopyWith<$Res>  {
  factory $Stage5InvoiceDataCopyWith(Stage5InvoiceData value, $Res Function(Stage5InvoiceData) _then) = _$Stage5InvoiceDataCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, DateTime date, List<InvoiceQualityLine> lines
});




}
/// @nodoc
class _$Stage5InvoiceDataCopyWithImpl<$Res>
    implements $Stage5InvoiceDataCopyWith<$Res> {
  _$Stage5InvoiceDataCopyWithImpl(this._self, this._then);

  final Stage5InvoiceData _self;
  final $Res Function(Stage5InvoiceData) _then;

/// Create a copy of Stage5InvoiceData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? lines = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceQualityLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [Stage5InvoiceData].
extension Stage5InvoiceDataPatterns on Stage5InvoiceData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stage5InvoiceData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stage5InvoiceData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stage5InvoiceData value)  $default,){
final _that = this;
switch (_that) {
case _Stage5InvoiceData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stage5InvoiceData value)?  $default,){
final _that = this;
switch (_that) {
case _Stage5InvoiceData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  List<InvoiceQualityLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stage5InvoiceData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  DateTime date,  List<InvoiceQualityLine> lines)  $default,) {final _that = this;
switch (_that) {
case _Stage5InvoiceData():
return $default(_that.id,_that.projectId,_that.date,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  DateTime date,  List<InvoiceQualityLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _Stage5InvoiceData() when $default != null:
return $default(_that.id,_that.projectId,_that.date,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Stage5InvoiceData implements Stage5InvoiceData {
  const _Stage5InvoiceData({required this.id, required this.projectId, required this.date, required final  List<InvoiceQualityLine> lines}): _lines = lines;
  factory _Stage5InvoiceData.fromJson(Map<String, dynamic> json) => _$Stage5InvoiceDataFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  DateTime date;
 final  List<InvoiceQualityLine> _lines;
@override List<InvoiceQualityLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of Stage5InvoiceData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Stage5InvoiceDataCopyWith<_Stage5InvoiceData> get copyWith => __$Stage5InvoiceDataCopyWithImpl<_Stage5InvoiceData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Stage5InvoiceDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stage5InvoiceData&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,date,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'Stage5InvoiceData(id: $id, projectId: $projectId, date: $date, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$Stage5InvoiceDataCopyWith<$Res> implements $Stage5InvoiceDataCopyWith<$Res> {
  factory _$Stage5InvoiceDataCopyWith(_Stage5InvoiceData value, $Res Function(_Stage5InvoiceData) _then) = __$Stage5InvoiceDataCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, DateTime date, List<InvoiceQualityLine> lines
});




}
/// @nodoc
class __$Stage5InvoiceDataCopyWithImpl<$Res>
    implements _$Stage5InvoiceDataCopyWith<$Res> {
  __$Stage5InvoiceDataCopyWithImpl(this._self, this._then);

  final _Stage5InvoiceData _self;
  final $Res Function(_Stage5InvoiceData) _then;

/// Create a copy of Stage5InvoiceData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? date = null,Object? lines = null,}) {
  return _then(_Stage5InvoiceData(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<InvoiceQualityLine>,
  ));
}


}


/// @nodoc
mixin _$InvoiceQualityLine {

 BasketQuality get quality; int get totalKg; double get bultos; double get pricePerBulto; double get subtotal;
/// Create a copy of InvoiceQualityLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceQualityLineCopyWith<InvoiceQualityLine> get copyWith => _$InvoiceQualityLineCopyWithImpl<InvoiceQualityLine>(this as InvoiceQualityLine, _$identity);

  /// Serializes this InvoiceQualityLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceQualityLine&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.bultos, bultos) || other.bultos == bultos)&&(identical(other.pricePerBulto, pricePerBulto) || other.pricePerBulto == pricePerBulto)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality,totalKg,bultos,pricePerBulto,subtotal);

@override
String toString() {
  return 'InvoiceQualityLine(quality: $quality, totalKg: $totalKg, bultos: $bultos, pricePerBulto: $pricePerBulto, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $InvoiceQualityLineCopyWith<$Res>  {
  factory $InvoiceQualityLineCopyWith(InvoiceQualityLine value, $Res Function(InvoiceQualityLine) _then) = _$InvoiceQualityLineCopyWithImpl;
@useResult
$Res call({
 BasketQuality quality, int totalKg, double bultos, double pricePerBulto, double subtotal
});




}
/// @nodoc
class _$InvoiceQualityLineCopyWithImpl<$Res>
    implements $InvoiceQualityLineCopyWith<$Res> {
  _$InvoiceQualityLineCopyWithImpl(this._self, this._then);

  final InvoiceQualityLine _self;
  final $Res Function(InvoiceQualityLine) _then;

/// Create a copy of InvoiceQualityLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quality = null,Object? totalKg = null,Object? bultos = null,Object? pricePerBulto = null,Object? subtotal = null,}) {
  return _then(_self.copyWith(
quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,totalKg: null == totalKg ? _self.totalKg : totalKg // ignore: cast_nullable_to_non_nullable
as int,bultos: null == bultos ? _self.bultos : bultos // ignore: cast_nullable_to_non_nullable
as double,pricePerBulto: null == pricePerBulto ? _self.pricePerBulto : pricePerBulto // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceQualityLine].
extension InvoiceQualityLinePatterns on InvoiceQualityLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceQualityLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceQualityLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceQualityLine value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceQualityLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceQualityLine value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceQualityLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BasketQuality quality,  int totalKg,  double bultos,  double pricePerBulto,  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceQualityLine() when $default != null:
return $default(_that.quality,_that.totalKg,_that.bultos,_that.pricePerBulto,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BasketQuality quality,  int totalKg,  double bultos,  double pricePerBulto,  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _InvoiceQualityLine():
return $default(_that.quality,_that.totalKg,_that.bultos,_that.pricePerBulto,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BasketQuality quality,  int totalKg,  double bultos,  double pricePerBulto,  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceQualityLine() when $default != null:
return $default(_that.quality,_that.totalKg,_that.bultos,_that.pricePerBulto,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceQualityLine implements InvoiceQualityLine {
  const _InvoiceQualityLine({required this.quality, required this.totalKg, required this.bultos, required this.pricePerBulto, required this.subtotal});
  factory _InvoiceQualityLine.fromJson(Map<String, dynamic> json) => _$InvoiceQualityLineFromJson(json);

@override final  BasketQuality quality;
@override final  int totalKg;
@override final  double bultos;
@override final  double pricePerBulto;
@override final  double subtotal;

/// Create a copy of InvoiceQualityLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceQualityLineCopyWith<_InvoiceQualityLine> get copyWith => __$InvoiceQualityLineCopyWithImpl<_InvoiceQualityLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceQualityLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceQualityLine&&(identical(other.quality, quality) || other.quality == quality)&&(identical(other.totalKg, totalKg) || other.totalKg == totalKg)&&(identical(other.bultos, bultos) || other.bultos == bultos)&&(identical(other.pricePerBulto, pricePerBulto) || other.pricePerBulto == pricePerBulto)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,quality,totalKg,bultos,pricePerBulto,subtotal);

@override
String toString() {
  return 'InvoiceQualityLine(quality: $quality, totalKg: $totalKg, bultos: $bultos, pricePerBulto: $pricePerBulto, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$InvoiceQualityLineCopyWith<$Res> implements $InvoiceQualityLineCopyWith<$Res> {
  factory _$InvoiceQualityLineCopyWith(_InvoiceQualityLine value, $Res Function(_InvoiceQualityLine) _then) = __$InvoiceQualityLineCopyWithImpl;
@override @useResult
$Res call({
 BasketQuality quality, int totalKg, double bultos, double pricePerBulto, double subtotal
});




}
/// @nodoc
class __$InvoiceQualityLineCopyWithImpl<$Res>
    implements _$InvoiceQualityLineCopyWith<$Res> {
  __$InvoiceQualityLineCopyWithImpl(this._self, this._then);

  final _InvoiceQualityLine _self;
  final $Res Function(_InvoiceQualityLine) _then;

/// Create a copy of InvoiceQualityLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quality = null,Object? totalKg = null,Object? bultos = null,Object? pricePerBulto = null,Object? subtotal = null,}) {
  return _then(_InvoiceQualityLine(
quality: null == quality ? _self.quality : quality // ignore: cast_nullable_to_non_nullable
as BasketQuality,totalKg: null == totalKg ? _self.totalKg : totalKg // ignore: cast_nullable_to_non_nullable
as int,bultos: null == bultos ? _self.bultos : bultos // ignore: cast_nullable_to_non_nullable
as double,pricePerBulto: null == pricePerBulto ? _self.pricePerBulto : pricePerBulto // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
