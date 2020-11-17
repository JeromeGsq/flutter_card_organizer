import 'package:flutter/foundation.dart';

/// A [ChangeNotifier] that holds a single value.
///
/// When [value] is set, this class notifies its listeners.
class EveryValueNotifier<T> extends ChangeNotifier
    implements ValueListenable<T> {
  /// Creates a [ChangeNotifier] that wraps this value.
  EveryValueNotifier(this._value);

  /// The current value stored in this notifier.
  ///
  /// When the value is set, this class notifies its listeners.
  @override
  T get value => _value;
  T _value;
  set value(T newValue) {
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
