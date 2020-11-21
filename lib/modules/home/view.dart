import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/event_listener.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_card_organizer/data/sources/file_picker.dart';
import 'package:flutter_card_organizer/modules/home/view_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AppMLKit, HomeViewModel>(
      create: (_) => HomeViewModel(),
      update: (_, appMLKit, vm) => vm
        ..appMLKit = appMLKit
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          FlatButton(
            highlightColor: Colors.white30,
            splashColor: Colors.white30,
            child: const Icon(
              Icons.straighten_outlined,
              color: Colors.white,
            ),
            onPressed: () => viewModel.processImage(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_photo_alternate),
        tooltip: 'Select a picture to scan',
        onPressed: () async {
          viewModel.picture = await filePicker.pickPhoto();
          viewModel.processImage();
          if (viewModel.picture != null) {
            Fluttertoast.showToast(
              msg: 'You can zoom & pan your picture',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
      body: viewModel.picture == null
          ? const Text('Select a picture')
          : Center(
              child: InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(200),
                minScale: 0.1,
                constrained: false,
                child: TextLabeledImage(
                  picture: viewModel.image,
                  recognizedElements: viewModel.recognizedElements,
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
  }) : super(key: key);

  final ui.Image picture;
  final List<RecognizedElement> recognizedElements;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        picture?.width?.toDouble() ?? 0,
        picture?.height?.toDouble() ?? 0,
      ),
      painter: ImageEditor(
        context: context,
        image: picture,
        recognizedElements: recognizedElements,
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    @required this.context,
    @required this.image,
    @required this.recognizedElements,
  });

  final BuildContext context;
  final ui.Image image;
  final List<RecognizedElement> recognizedElements;

  final imagePainter = Paint();

  final outline = Paint()
    ..color = Colors.blue[600]
    ..isAntiAlias = true
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;

  final fill = Paint()
    ..color = Colors.white30
    ..isAntiAlias = true
    ..strokeWidth = 20
    ..style = PaintingStyle.fill;

  @override
  bool hitTest(Offset position) {
    for (RecognizedElement element in recognizedElements) {
      if (element.boundingBox.contains(position)) {
        print(element.text);
        break;
      }
    }
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(
        image,
        Offset.zero,
        imagePainter,
      );
    }

    for (RecognizedElement element in recognizedElements) {
      canvas.drawRect(element.boundingBox, fill);
      canvas.drawRect(element.boundingBox, outline);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
