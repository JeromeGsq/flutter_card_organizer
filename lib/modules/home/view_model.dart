import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';

class HomeViewModel extends ViewModel {
  AppMLKit appMLKit;

  File _picture;
  File get picture => _picture;
  set picture(File value) {
    if (_picture != value && value != null) {
      _picture = value;
      _loadImage();
      notifyListeners();
    }
  }

  Image _image;
  Image get image => _image;

  Future<void> _loadImage() async {
    final bytes = await picture.readAsBytes();
    decodeImageFromList(bytes, (result) {
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

  Future<void> processImage() async {
    recognizedElements = [];
    recognizedElements = await appMLKit.recognizeText(_picture);
  }
}
