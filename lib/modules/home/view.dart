import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/event_listener.dart';
import 'package:flutter_card_organizer/modules/home/view_model.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel()..load(),
      child: EventListener<HomeViewModel>(
        listener: (context, event) {},
        child: const View(),
      ),
    );
  }
}

class View extends StatelessWidget {
  const View({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.photo),
        tooltip: 'Select a picture to scan',
        onPressed: () {},
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
