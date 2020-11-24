import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AppProcessImages {
  Future<Uint8List> crop(
    Uint8List file,
    RectPoint rectPoint,
  ) async {
    const padding = 20;
    final topLeft = Offset(
      -padding +
          (rectPoint.tl.dx < rectPoint.bl.dx
              ? rectPoint.tl.dx
              : rectPoint.bl.dx),
      -padding +
          (rectPoint.tl.dy < rectPoint.bl.dy
              ? rectPoint.tl.dy
              : rectPoint.bl.dy),
    );
    final bottomRight = Offset(
      padding +
          (rectPoint.tr.dx > rectPoint.br.dx
              ? rectPoint.tr.dx
              : rectPoint.br.dx),
      padding +
          (rectPoint.tr.dy > rectPoint.br.dy
              ? rectPoint.tr.dy
              : rectPoint.br.dy),
    );

    final option = ImageEditorOption()
      ..addOption(
        ClipOption.fromRect(Rect.fromPoints(topLeft, bottomRight)),
      );

    final result = await ImageEditor.editImage(
      image: file,
      imageEditorOption: option,
    );

    return result;
  }

  Future<Uint8List> rotate(
    Uint8List file,
    RectPoint rectPoint,
  ) async {
    final angle = _getRadAngleCorrection(rectPoint.tl, rectPoint.tr);

    final option = ImageEditorOption()
      ..addOption(
        RotateOption.radian(angle),
      );

    final result = await ImageEditor.editImage(
      image: file,
      imageEditorOption: option,
    );

    return result;
  }

  Future<RectPoint> getRect(
    String path,
    int width,
    int height,
  ) async {
    final rectPoint = await FlutterSmartCropper.detectImageRect(path);
    if (height > width) {
      final tl = rectPoint.tl;
      final tr = rectPoint.tr;
      final bl = rectPoint.bl;
      final br = rectPoint.br;
      rectPoint.tl = Offset(width - tl.dy, tl.dx);
      rectPoint.tr = Offset(width - tr.dy, tr.dx);
      rectPoint.bl = Offset(width - bl.dy, bl.dx);
      rectPoint.br = Offset(width - br.dy, br.dx);
    }

    return rectPoint;
  }

  Future<List<RecognizedElement>> recognizeText(
    Uint8List file,
    int width,
    int height,
  ) async {
    if (file == null) {
      throw Exception('imageFile is null');
    }
    final directory = await getApplicationDocumentsDirectory();
    final imgFile = File(join(directory.path, 'temp.jpg'));
    imgFile.writeAsBytesSync(file);

    final visionImage = FirebaseVisionImage.fromFile(imgFile);
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

    final result =
        math.atan2(offset1.dy - offsetBase.dy, offset1.dx - offsetBase.dx) -
            math.atan2(offset2.dy - offsetBase.dy, offset2.dx - offsetBase.dx);

    return result < 0 ? result * -1 : result;
  }
}
