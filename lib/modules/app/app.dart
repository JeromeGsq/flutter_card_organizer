import 'dart:async';

import 'package:flutter_card_organizer/core/config/config.dart';
import 'package:flutter_card_organizer/modules/app/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_organizer/modules/splash/view.dart';
import 'package:logging/logging.dart';

class App extends StatefulWidget {
  const App({
    Key key,
    @required this.config,
  })  : assert(config != null),
        super(key: key);

  final Config config;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  StreamSubscription<LogRecord> _logRecordSubscription;

  @override
  void initState() {
    super.initState();
    if (widget.config.loggerLevel != Level.OFF) {
      _logRecordSubscription = Logger.root.onRecord.listen((record) {
        debugPrint(
            '${record.level.name} ${record.time} [${record.loggerName}]: ${record.message}');
      });
    }
  }

  @override
  void dispose() {
    _logRecordSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      config: widget.config,
      child: MaterialApp(
        title: widget.config.appName,
        home: const SplashView(),
        //onGenerateRoute: const DefaultAppRouter().onGenerateRoute,
      ),
    );
  }
}
