import 'package:flutter/cupertino.dart';

abstract class ViewModel extends ChangeNotifier {
  Future<void> load();
}
