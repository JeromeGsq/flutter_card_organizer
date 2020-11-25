import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';
import 'package:image/image.dart';
import 'package:image_editor/image_editor.dart';
import 'package:opencv/core/imgproc.dart';
import 'package:opencv/opencv.dart';

class AppProcessImages {
  Future<File> crop(
    String path,
    RectPoint rectPoint,
    double width,
    double height, {
    double padding = 20,
  }) async {
    final x = [
      rectPoint.tl.dx,
      rectPoint.bl.dx,
      rectPoint.tr.dx,
      rectPoint.br.dx
    ];
    final y = [
      rectPoint.tl.dy,
      rectPoint.bl.dy,
      rectPoint.tr.dy,
      rectPoint.br.dy
    ];

    var topLeft = Offset(
      min(x),
      min(y),
    );
    var bottomRight = Offset(
      max(x),
      max(y),
    );

    topLeft = Offset(
      clamp(topLeft.dx - padding, min: 0),
      clamp(topLeft.dy - padding, min: 0),
    );
    bottomRight = Offset(
      clamp(bottomRight.dx + padding, max: width),
      clamp(bottomRight.dy + padding, max: height),
    );

    final option = ImageEditorOption()
      ..addOption(
        ClipOption.fromOffset(topLeft, bottomRight),
      );

    final result = await ImageEditor.editFileImageAndGetFile(
      file: File(path),
      imageEditorOption: option,
    );

    return result;
  }

  Future<File> rotate(
    String path,
    RectPoint rectPoint,
  ) async {
    var angle = _getRadAngleCorrection(rectPoint.tl, rectPoint.tr);

    if (rectPoint.tl.dy < rectPoint.tr.dy) {
      angle = -angle;
    } else {}

    final option = ImageEditorOption()
      ..addOption(
        RotateOption.radian(angle),
      );

    final result = await ImageEditor.editFileImageAndGetFile(
      file: File(path),
      imageEditorOption: option,
    );

    return result;
  }

  Future<File> unskew(
    String path,
    RectPoint rectPoint,
    int resultWidth,
    int resultHeight,
  ) async {
    final destinationPoints = [
      //TL
      0,
      0,
      //TR
      resultWidth,
      0,
      //BL
      0,
      resultHeight,
      //BR
      resultWidth,
      resultHeight
    ];

    final outputSize = [
      resultWidth.toDouble(),
      resultHeight.toDouble(),
    ];

    final res = await ImgProc.warpPerspectiveTransform(
      await File(path).readAsBytes(),
      sourcePoints: [
        //TL
        rectPoint.tl.dx.toInt(),
        rectPoint.tl.dy.toInt(),
        //TR
        rectPoint.tr.dx.toInt(),
        rectPoint.tr.dy.toInt(),
        //BL
        rectPoint.bl.dx.toInt(),
        rectPoint.bl.dy.toInt(),
        //BR
        rectPoint.br.dx.toInt(),
        rectPoint.br.dy.toInt(),
      ],
      destinationPoints: destinationPoints,
      outputSize: outputSize,
    );

    final data = res as Uint8List;
    final file = await saveImage(data, path);
    return file;
  }

  Future<RectPoint> getRect(
    String path,
  ) async =>
      FlutterSmartCropper.detectImageRect(
        path,
      );

  Future<List<RecognizedElement>> recognizeText(
    String path,
  ) async {
    final visionImage = FirebaseVisionImage.fromFile(File(path));
    final textRecognizer = FirebaseVision.instance.textRecognizer();
    final visionText = await textRecognizer.processImage(visionImage);

    final List<RecognizedElement> elements = [];

    try {
      visionText.blocks.forEach(
        (element) => elements.add(
          RecognizedElement(
            boundingBox: element.boundingBox,
            cornerPoints: element.cornerPoints,
            text: element.text,
          ),
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      textRecognizer.close();
    }

    return elements;
  }

  double _getRadAngleCorrection(
    Offset a,
    Offset b,
  ) {
    final offsetBase = Offset(a.dx, a.dy);
    final offset1 = Offset(b.dx, b.dy);
    final offset2 = Offset(b.dx, a.dy);

    final result = math.atan2(
          offset1.dy - offsetBase.dy,
          offset1.dx - offsetBase.dx,
        ) -
        math.atan2(
          offset2.dy - offsetBase.dy,
          offset2.dx - offsetBase.dx,
        );

    return result < 0 ? result * -1 : result;
  }

  double min(List<double> values) {
    return values.reduce(math.min);
  }

  double max(List<double> values) {
    return values.reduce(math.max);
  }

  double clamp(double value, {double min, double max}) {
    min ??= value;
    max ??= value;
    return value < min ? min : (value > max ? max : value);
  }

  Future<File> saveImage(Uint8List data, String path) async {
    final image = decodeImage(data);
    final file = File(path);
    file.writeAsBytes(encodePng(image));
    return file;
  }
}
