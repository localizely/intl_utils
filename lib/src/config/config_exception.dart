class ConfigException implements Exception {
  final String message;

  ConfigException(this.message);

  @override
  String toString() => 'ConfigException: $message';
}
