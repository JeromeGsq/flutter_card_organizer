// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'recognized_element.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$RecognizedElementTearOff {
  const _$RecognizedElementTearOff();

// ignore: unused_element
  _RecognizedElement call(
      {Rect boundingBox, List<Offset> cornerPoints, String text}) {
    return _RecognizedElement(
      boundingBox: boundingBox,
      cornerPoints: cornerPoints,
      text: text,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $RecognizedElement = _$RecognizedElementTearOff();

/// @nodoc
mixin _$RecognizedElement {
  Rect get boundingBox;
  List<Offset> get cornerPoints;
  String get text;

  $RecognizedElementCopyWith<RecognizedElement> get copyWith;
}

/// @nodoc
abstract class $RecognizedElementCopyWith<$Res> {
  factory $RecognizedElementCopyWith(
          RecognizedElement value, $Res Function(RecognizedElement) then) =
      _$RecognizedElementCopyWithImpl<$Res>;
  $Res call({Rect boundingBox, List<Offset> cornerPoints, String text});
}

/// @nodoc
class _$RecognizedElementCopyWithImpl<$Res>
    implements $RecognizedElementCopyWith<$Res> {
  _$RecognizedElementCopyWithImpl(this._value, this._then);

  final RecognizedElement _value;
  // ignore: unused_field
  final $Res Function(RecognizedElement) _then;

  @override
  $Res call({
    Object boundingBox = freezed,
    Object cornerPoints = freezed,
    Object text = freezed,
  }) {
    return _then(_value.copyWith(
      boundingBox:
          boundingBox == freezed ? _value.boundingBox : boundingBox as Rect,
      cornerPoints: cornerPoints == freezed
          ? _value.cornerPoints
          : cornerPoints as List<Offset>,
      text: text == freezed ? _value.text : text as String,
    ));
  }
}

/// @nodoc
abstract class _$RecognizedElementCopyWith<$Res>
    implements $RecognizedElementCopyWith<$Res> {
  factory _$RecognizedElementCopyWith(
          _RecognizedElement value, $Res Function(_RecognizedElement) then) =
      __$RecognizedElementCopyWithImpl<$Res>;
  @override
  $Res call({Rect boundingBox, List<Offset> cornerPoints, String text});
}

/// @nodoc
class __$RecognizedElementCopyWithImpl<$Res>
    extends _$RecognizedElementCopyWithImpl<$Res>
    implements _$RecognizedElementCopyWith<$Res> {
  __$RecognizedElementCopyWithImpl(
      _RecognizedElement _value, $Res Function(_RecognizedElement) _then)
      : super(_value, (v) => _then(v as _RecognizedElement));

  @override
  _RecognizedElement get _value => super._value as _RecognizedElement;

  @override
  $Res call({
    Object boundingBox = freezed,
    Object cornerPoints = freezed,
    Object text = freezed,
  }) {
    return _then(_RecognizedElement(
      boundingBox:
          boundingBox == freezed ? _value.boundingBox : boundingBox as Rect,
      cornerPoints: cornerPoints == freezed
          ? _value.cornerPoints
          : cornerPoints as List<Offset>,
      text: text == freezed ? _value.text : text as String,
    ));
  }
}

/// @nodoc
class _$_RecognizedElement implements _RecognizedElement {
  _$_RecognizedElement({this.boundingBox, this.cornerPoints, this.text});

  @override
  final Rect boundingBox;
  @override
  final List<Offset> cornerPoints;
  @override
  final String text;

  @override
  String toString() {
    return 'RecognizedElement(boundingBox: $boundingBox, cornerPoints: $cornerPoints, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RecognizedElement &&
            (identical(other.boundingBox, boundingBox) ||
                const DeepCollectionEquality()
                    .equals(other.boundingBox, boundingBox)) &&
            (identical(other.cornerPoints, cornerPoints) ||
                const DeepCollectionEquality()
                    .equals(other.cornerPoints, cornerPoints)) &&
            (identical(other.text, text) ||
                const DeepCollectionEquality().equals(other.text, text)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(boundingBox) ^
      const DeepCollectionEquality().hash(cornerPoints) ^
      const DeepCollectionEquality().hash(text);

  @override
  _$RecognizedElementCopyWith<_RecognizedElement> get copyWith =>
      __$RecognizedElementCopyWithImpl<_RecognizedElement>(this, _$identity);
}

abstract class _RecognizedElement implements RecognizedElement {
  factory _RecognizedElement(
      {Rect boundingBox,
      List<Offset> cornerPoints,
      String text}) = _$_RecognizedElement;

  @override
  Rect get boundingBox;
  @override
  List<Offset> get cornerPoints;
  @override
  String get text;
  @override
  _$RecognizedElementCopyWith<_RecognizedElement> get copyWith;
}
