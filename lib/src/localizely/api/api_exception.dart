class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String body;

  ApiException(this.message, this.statusCode, this.body);

  String getFormattedMessage() {
    return '$message\n$body';
  }

  @override
  String toString() =>
      'ApiException: $message. Status code: $statusCode. Body: $body';
}
