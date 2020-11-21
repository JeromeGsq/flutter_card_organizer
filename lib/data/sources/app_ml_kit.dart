import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';

class AppMLKit {
  Future<List<RecognizedElement>> recognizeText(File imageFile) async {
    if (imageFile == null) {
      throw Exception('imageFile is null');
    }

    final visionImage = FirebaseVisionImage.fromFile(imageFile);
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
}
