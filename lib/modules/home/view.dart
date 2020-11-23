import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/event_listener.dart';
import 'package:flutter_card_organizer/core/widgets/recongnized_image_text_painter.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_card_organizer/data/sources/file_picker.dart';
import 'package:flutter_card_organizer/modules/home/view_model.dart';
import 'package:flutter_smart_cropper/flutter_smart_cropper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AppProcessImages, HomeViewModel>(
      create: (_) => HomeViewModel(),
      update: (_, appProcessImages, vm) => vm
        ..appProcessImages = appProcessImages
        ..load(),
      child: EventListener<HomeViewModel>(
        listener: (context, event) {},
        child: const View(),
      ),
    );
  }
}

class View extends StatefulWidget {
  const View({
    Key key,
  }) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);
    final filePicker = Provider.of<AppFilePicker>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          FlatButton(
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
            child: const Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              viewModel.picture = null;
            },
          ),
          FlatButton(
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
            child: const Icon(
              Icons.straighten_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              await viewModel.processImage();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_photo_alternate),
        tooltip: 'Select a picture to scan',
        onPressed: () async {
          final picture = await filePicker.pickPhoto();
          viewModel.path = picture.path;
          viewModel.picture = picture.readAsBytesSync();
          if (viewModel.picture != null) {
            Fluttertoast.showToast(
              msg: 'You can zoom & pan your picture',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
      body: Center(
        child: viewModel.picture == null
            ? const Text('Select a picture to scan.')
            : InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(40),
                minScale: 0.1,
                constrained: false,
                child: TextLabeledImage(
                  picture: viewModel.image,
                  recognizedElements: viewModel.recognizedElements,
                  rectPoint: viewModel.rectPoint,
                ),
              ),
      ),
    );
  }
}

class TextLabeledImage extends StatelessWidget {
  const TextLabeledImage({
    Key key,
    @required this.picture,
    @required this.recognizedElements,
    @required this.rectPoint,
  }) : super(key: key);

  final ui.Image picture;
  final List<RecognizedElement> recognizedElements;
  final RectPoint rectPoint;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        picture?.width?.toDouble() ?? 0,
        picture?.height?.toDouble() ?? 0,
      ),
      painter: RecongnizedImageTextPainter(
        context: context,
        image: picture,
        recognizedElements: recognizedElements,
        rectPoint: rectPoint,
      ),
    );
  }
}
