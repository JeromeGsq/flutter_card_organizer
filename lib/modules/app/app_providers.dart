import 'package:flutter_card_organizer/core/config/config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/navigation.dart';
import 'package:flutter_card_organizer/data/sources/app_ml_kit.dart';
import 'package:flutter_card_organizer/data/sources/file_picker.dart';
import 'package:provider/provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    Key key,
    @required this.config,
    @required this.child,
  })  : assert(child != null),
        assert(config != null),
        super(key: key);

  final Widget child;
  final Config config;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Routes>(create: (_) => Routes()),
        Provider<AppFilePicker>(create: (_) => AppFilePicker()),
        Provider<AppProcessImages>(create: (_) => AppProcessImages()),
      ],
      child: child,
    );
  }
}
