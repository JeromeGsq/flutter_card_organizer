import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/modules/splash/view_model.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel()..load(),
      child: const View(),
    );
  }
}

class View extends StatelessWidget {
  const View({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SplashViewModel>(context);
    return Scaffold(
      body: Center(
        child: Text('Loading ${viewModel.loadValue.toString()}%'),
      ),
    );
  }
}
