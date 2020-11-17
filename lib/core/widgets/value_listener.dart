import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget which listen a single [listenable] and calls [onUpdated]
/// when the value held by the [listenable] is updated.
class ValueListener<T> extends StatefulWidget {
  /// Creates a [ValueListener].
  const ValueListener({
    Key key,
    @required this.listenable,
    @required this.onUpdated,
    @required this.child,
  })  : assert(listenable != null),
        assert(onUpdated != null),
        assert(child != null),
        super(key: key);

  /// The listenable to listen.
  final ValueListenable<T> listenable;

  /// Called when the value held by [listenable] is updated.
  final ValueChanged<T> onUpdated;

  /// The child.
  final Widget child;

  @override
  _ValueListenerState<T> createState() => _ValueListenerState<T>();
}

class _ValueListenerState<T> extends State<ValueListener<T>> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handleValueChanged);
  }

  @override
  void didUpdateWidget(ValueListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(_handleValueChanged);
      widget.listenable.addListener(_handleValueChanged);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_handleValueChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _handleValueChanged() {
    widget.onUpdated(widget.listenable.value);
  }
}
