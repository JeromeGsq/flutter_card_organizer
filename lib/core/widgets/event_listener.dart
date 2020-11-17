import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_organizer/core/view_model.dart';
import 'package:provider/provider.dart';

class EventListener<T extends ViewModel> extends StatefulWidget {
  EventListener({
    Key key,
    @required this.child,
    @required this.listener,
  }) : super(key: key);

  final Widget child;
  final void Function(BuildContext context, Object event) listener;

  ViewModel viewModel;

  @override
  _EventListenerState createState() => _EventListenerState<T>();
}

class _EventListenerState<T extends ViewModel> extends State<EventListener> {
  StreamSubscription<Object> _subscription;

  @override
  void initState() {
    super.initState();

    _subscribe();
  }

  @override
  void didUpdateWidget(EventListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel ??= Provider.of<T>(context);

    if (oldWidget.viewModel != widget.viewModel) {
      if (_subscription != null) {
        _unsubscribe();
      }
      _subscribe();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.viewModel != null) {
      _subscription = widget.viewModel.events.listen((Object event) {
        widget.listener.call(context, event);
      });
    }
  }

  void _unsubscribe() {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }
  }
}
