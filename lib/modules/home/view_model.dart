import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';

class HomeViewModel extends ViewModel {
  AppProcessImages appProcessImages;

  String _path;
  String get path => _path;
  set path(String value) {
    if (_path != value) {
      _path = value;
      notifyListeners();
    }
  }

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

  RectPoint _rectPoint;
  RectPoint get rectPoint => _rectPoint;
  set rectPoint(RectPoint value) {
    if (_rectPoint != value) {
      _rectPoint = value;
      notifyListeners();
    }
  }

  List<RecognizedElement> _recognizedElements = [];
  List<RecognizedElement> get recognizedElements => _recognizedElements;
  set recognizedElements(List<RecognizedElement> value) {
    if (_recognizedElements != value) {
      _recognizedElements = value;
      notifyListeners();
    }
  }

  Future<void> processImage() async {
    rectPoint = await appProcessImages.getRect(path);
  }
}
