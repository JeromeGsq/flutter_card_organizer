import 'package:flutter_card_organizer/core/config/config.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// The exception thrown when a called to the API has
/// not been successful.
class ApiClientException implements Exception {
  ApiClientException._({
    this.message,
    @required this.code,
  });

  /// The message returned by the API.
  final String message;

  /// The HTTP status code of the response.
  final int code;
}

/// A provider that fetches data from an API.
@immutable
class ApiClient {
  /// Creates a new [ApiClient].
  ApiClient({
    Client client,
    this.config,
  }) : _client = client ?? Client();

  // ignore: unused_field
  final Client _client;

  /// The configuration to use when calling the API.
  final Config config;
}
