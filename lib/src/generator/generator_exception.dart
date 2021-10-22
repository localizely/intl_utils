class GeneratorException implements Exception {
  final String message;

  GeneratorException(this.message);

  @override
  String toString() => 'GeneratorException: $message';
}
