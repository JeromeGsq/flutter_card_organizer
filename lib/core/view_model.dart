import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  /// Creates a new view model.
  ViewModel() : _streamController = StreamController.broadcast();

  final StreamController<Object> _streamController;
  Stream<Object> get events => _streamController.stream;

  Future<void> load() async {}

  @override
  void dispose() {
    _streamController?.close();
    super.dispose();
  }

  void dispatch(Object event) {
    _streamController.sink.add(event);
  }
}
