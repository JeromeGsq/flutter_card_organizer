import 'package:flutter_card_organizer/core/notifiers/busy.dart';
import 'package:flutter_card_organizer/core/view_model.dart';

class SplashViewModel extends ViewModel with BusyNotifier {
  double _loadValue = 0;
  double get loadValue => _loadValue;
  set loadValue(double value) {
    if (loadValue != value) {
      _loadValue = value;
      notifyListeners();
    }
  }

  @override
  Future<void> load() async {
    for (double i = 0; i <= 100; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      loadValue = i;
    }
  }
}
