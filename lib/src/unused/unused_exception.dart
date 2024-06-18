class UnusedException implements Exception {
  final String message;

  UnusedException(this.message);

  @override
  String toString() => 'UnusedException: $message';
}
