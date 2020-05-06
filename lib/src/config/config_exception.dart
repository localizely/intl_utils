class ConfigException implements Exception {
  final String message;

  ConfigException(this.message);

  @override
  String toString() {
    return 'ConfigException: ${message ?? ""}';
  }
}
