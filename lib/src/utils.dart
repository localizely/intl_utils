import 'dart:io';

bool validateClassName(dynamic value) {
  return (value is String) && (RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(value));
}

void info(String message) {
  stdout.writeln('[INFO] $message');
}

void warning(String message) {
  stdout.writeln('[WARNING] $message');
}

void error(String message) {
  stderr.writeln('[ERROR] $message');
}
