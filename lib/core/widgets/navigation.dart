import 'package:flutter/material.dart';
import 'package:flutter_card_organizer/modules/home/view.dart';
import 'package:flutter_card_organizer/modules/splash/view.dart';

class Routes {
  MaterialPageRoute<void> spashView() => MaterialPageRoute(
        builder: (context) => const SplashView(),
      );

  MaterialPageRoute<void> homeView() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
}
