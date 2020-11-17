import 'package:flutter_card_organizer/core/config/config.dart';
import 'package:flutter_card_organizer/modules/app/app.dart';
import 'package:flutter/widgets.dart';

Future<void> run(Config config) async {
  runApp(
    App(config: config),
  );
}
