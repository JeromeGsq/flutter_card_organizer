import 'dart:io';
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
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Center(
            child: viewModel.path == null
                ? const Text(
                    'Select a picture to scan',
                    style: TextStyle(color: Colors.white),
                  )
                : FutureBuilder<ui.Image>(
                    initialData: null,
                    future: _getUiImage(viewModel.path),
                    builder: (_, value) {
                      return value.data == null
                          ? const CircularProgressIndicator()
                          : InteractiveViewer(
                              boundaryMargin: const EdgeInsets.all(1000),
                              minScale: 0.1,
                              constrained: false,
                              child: Transform.scale(
                                scale: 1,
                                child: TextLabeledImage(
                                  image: value.data,
                                  recognizedElements:
                                      viewModel.recognizedElements,
                                  rectPoint: viewModel.rectPoint,
                                  onTextPressed: (text) {
                                    viewModel.text = text;
                                  },
                                ),
                              ),
                            );
                    },
                  ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppButton(
                      text: 'Edges',
                      onPressed: () async {
                        await viewModel.detectEdges();
                      },
                    ),
                    AppButton(
                      text: 'Text',
                      onPressed: () async {
                        await viewModel.processImage();
                      },
                    ),
                    AppButton(
                      text: 'Skew',
                      onPressed: () async {
                        await viewModel.unskew();
                      },
                    ),
                  ],
                ),
                Container(
                  color: Colors.white30,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      viewModel.text,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 1; i <= 5; i++)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 16),
                      child: AppButton(
                        text: '$i',
                        onPressed: () => viewModel.generateAssetsImagesInPath(
                          imageName: '$i.jpg',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton(
          child: const Icon(Icons.add_photo_alternate),
          tooltip: 'Select a picture to scan',
          onPressed: () async {
            viewModel.path = (await filePicker.pickPhoto())?.path;
          },
        ),
      ),
    );
  }

  Future<ui.Image> _getUiImage(
    String imageAssetPath,
  ) async {
    final data = await File(imageAssetPath).readAsBytes();
    final codec = await ui.instantiateImageCodec(data);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    Key key,
    @required this.text,
    @required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: MaterialButton(
        color: Colors.blue,
        child: Text('$text', style: const TextStyle(color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}

class TextLabeledImage extends StatelessWidget {
  const TextLabeledImage({
    Key key,
    @required this.image,
    @required this.recognizedElements,
    @required this.rectPoint,
    @required this.onTextPressed,
  }) : super(key: key);

  final ui.Image image;
  final List<RecognizedElement> recognizedElements;
  final RectPoint rectPoint;
  final ValueChanged<String> onTextPressed;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(
        image?.width?.toDouble() ?? 0,
        image?.height?.toDouble() ?? 0,
      ),
      painter: RecongnizedImageTextPainter(
        context: context,
        image: image,
        recognizedElements: recognizedElements,
        rectPoint: rectPoint,
        onTextPressed: onTextPressed,
      ),
    );
  }
}
