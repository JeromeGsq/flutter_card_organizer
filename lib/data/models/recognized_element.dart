import 'dart:ui';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recognized_element.freezed.dart';

@freezed
abstract class RecognizedElement with _$RecognizedElement {
  factory RecognizedElement({
    Rect boundingBox,
    List<Offset> cornerPoints,
    String text,
  }) = _RecognizedElement;
}
