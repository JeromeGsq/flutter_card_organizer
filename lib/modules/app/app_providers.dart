import 'package:flutter_card_organizer/core/config/config.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_card_organizer/core/widgets/navigation.dart';
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
      ],
      child: child,
    );
  }
}
