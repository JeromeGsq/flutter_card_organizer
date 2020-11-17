import 'package:flutter_card_organizer/core/notifiers/busy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Listens a [BusyNotifier] and displays either a loader or the child
/// depending on the [BusyNotifier.busy] value.
class BusyListener<T extends BusyNotifier> extends StatelessWidget {
  /// Creates a [BusyListener].
  const BusyListener({
    Key key,
    @required this.child,
    this.loader = const _DefaultLoader(),
  }) : super(key: key);

  final Widget child;
  final Widget loader;

  @override
  Widget build(BuildContext context) {
    final busyNotifier = Provider.of<T>(context);
    return busyNotifier.busy ? loader : child;
  }
}

class _DefaultLoader extends StatelessWidget {
  const _DefaultLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
