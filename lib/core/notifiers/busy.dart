import 'package:flutter/material.dart';

/// A mixin used to notify when the view is busy.
mixin BusyNotifier on ChangeNotifier {
  bool get busy => _busy;
  bool _busy = false;
  @protected
  set busy(bool value) {
    assert(value != null);
    if (_busy != value) {
      _busy = value;
      notifyListeners();
    }
  }
}
