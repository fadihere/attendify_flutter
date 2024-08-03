class ServerException implements Exception {
  final Map<String, dynamic>? response;
  ServerException(this.response);
}

class CacheException implements Exception {}

class UnknownExpection implements Exception {}

class LocationServiceDisabledException implements Exception {
  /// Constructs the [LocationServiceDisabledException]
  const LocationServiceDisabledException();

  @override
  String toString() => 'The location service on the device is disabled.';
}
