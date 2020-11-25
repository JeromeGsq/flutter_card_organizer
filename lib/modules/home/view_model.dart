import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<void> generateAssetsImagesInPath({
    String imageName = '1.jpg',
  }) async {
    final byteData = await rootBundle.load('assets/$imageName');

    final tempPath = '${(await getTemporaryDirectory()).path}/$imageName';
    final file = File(tempPath);
    try {
      await file.create();
    } catch (e) {
      await file.delete();
      await file.create();

      print(e);
    }
    await file.writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );

    path = tempPath;
  }

  Future<void> detectEdges() async {
    rectPoint = await appProcessImages.getRect(path);
    notifyListeners();
  }

  Future<void> crop() async {
    try {
      final size = ImageSizeGetter.getSize(FileInput(File(path)));
      rectPoint = await appProcessImages.getRect(path);

      final data = await appProcessImages.crop(
        path,
        rectPoint,
        size.width.toDouble(),
        size.height.toDouble(),
        padding: 100,
      );

      await data.copy(path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> rotate() async {
    try {
      rectPoint = await appProcessImages.getRect(path);
      final data = await appProcessImages.rotate(path, rectPoint);

      await data.copy(path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> unskew() async {
    try {
      rectPoint = await appProcessImages.getRect(path);
      final data = await appProcessImages.unskew(path, rectPoint);

      await data.copy(path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
