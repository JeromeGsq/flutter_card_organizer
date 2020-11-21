import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:image_editor/image_editor.dart';
import 'package:path_provider/path_provider.dart';

class AppProcessImages {
  Future<Uint8List> crop(Uint8List file, Rect rect) async {
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
}
