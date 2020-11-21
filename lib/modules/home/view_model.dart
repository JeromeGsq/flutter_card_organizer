import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';

class HomeViewModel extends ViewModel {
  AppProcessImages appProcessImages;

  Uint8List _picture;
  Uint8List get picture => _picture;
  set picture(Uint8List value) {
    if (_picture != value) {
      recognizedElements = [];
      _picture = value;
      _loadImage();
      notifyListeners();
    }
  }

  Image _image;
  Image get image => _image;

  Future<void> _loadImage() async {
    if (picture == null) {
      return;
    }
    decodeImageFromList(picture, (result) {
      _image = result;
      notifyListeners();
    });
  }

  List<RecognizedElement> _recognizedElements = [];
  List<RecognizedElement> get recognizedElements => _recognizedElements;
  set recognizedElements(List<RecognizedElement> value) {
    if (_recognizedElements != value) {
      _recognizedElements = value;
      notifyListeners();
    }
  }

  Future<void> clipAndRotateImage() async {
    if (picture == null) {
      return;
    }

    final temp = await appProcessImages.recognizeText(
      picture,
      image.width,
      image.height,
    );

    double left = double.maxFinite;
    double top = double.maxFinite;
    double right = 0;
    double bottom = 0;

    for (var i = 0; i < temp.length; i++) {
      left = temp[i].boundingBox.left < left ? temp[i].boundingBox.left : left;
      top = temp[i].boundingBox.top < top ? temp[i].boundingBox.top : top;
      right =
          temp[i].boundingBox.right > right ? temp[i].boundingBox.right : right;
      bottom = temp[i].boundingBox.bottom > bottom
          ? temp[i].boundingBox.bottom
          : bottom;
    }

    print('$left : $top : $right : $bottom');

    final padding = 0;

    picture = await appProcessImages.crop(
      picture,
      Rect.fromLTRB(
        left - padding,
        top - padding,
        right + padding,
        bottom + padding,
      ),
    );

    picture = await appProcessImages.rotate(picture, temp);
  }

  Future<void> processImage() async {
    recognizedElements = [];
    recognizedElements = await appProcessImages.recognizeText(
      picture,
      image.width,
      image.height,
    );
  }
}
