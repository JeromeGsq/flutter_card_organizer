import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_card_organizer/data/models/recognized_element.dart';

class RecongnizedImageTextPainter extends CustomPainter {
  RecongnizedImageTextPainter({
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
