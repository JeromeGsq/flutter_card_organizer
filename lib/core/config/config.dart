import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

/// Configuration for an application.
@immutable
abstract class Config {
  const Config._();

  /// Creates the configuration for the `development` environment.
  factory Config.dev() => const Dev._();

  /// Creates the configuration for the `production` environment.
  factory Config.prod() => const Prod._();

  /// Application Name.
  String get appName => 'Card Organizer';

  /// Level for the root-logger.
  Level get loggerLevel;
}

class Dev extends Config {
  const Dev._() : super._();

  @override
  Level get loggerLevel => Level.ALL;
}

class Prod extends Config {
  const Prod._() : super._();

  @override
  Level get loggerLevel => Level.OFF;
}
