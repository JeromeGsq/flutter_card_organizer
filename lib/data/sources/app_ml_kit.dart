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
    Rect rect,
  ) async {
    final option = ImageEditorOption()
      ..addOption(
        ClipOption.fromRect(rect),
      );

    final result = await ImageEditor.editImage(
      image: file,
      imageEditorOption: option,
    );

    return result;
  }

  Future<Uint8List> rotate(
    Uint8List file,
    List<RecognizedElement> recognizedElements,
  ) async {
    final List<Offset> ps = [];
    for (RecognizedElement element in recognizedElements) {
      ps.addAll(element.cornerPoints);
    }

    double middle = 0;
    double adder = 0;

    for (var i = 0; i < ps.length - 1; i = i = i + 2) {
      final a = _getRadAngleCorrection(ps[i], ps[i + 1]);
      if (a != 0) {
        adder++;
        if (middle == 0) {
          middle = a;
        } else {
          middle += a;
        }
      }
    }
    final angle = middle / adder;

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
  ) async {
    final rectPoint = await FlutterSmartCropper.detectImageRect(path);
    print(rectPoint);
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
