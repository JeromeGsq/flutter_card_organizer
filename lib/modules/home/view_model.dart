import 'dart:io';

import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';

class HomeViewModel extends ViewModel {
  AppMLKit appMLKit;

  File _picture;
  File get picture => _picture;
  set picture(File value) {
    if (_picture != value) {
      _picture = value;
      notifyListeners();
    }
  }

  Future<void> processImage() async {}
}
