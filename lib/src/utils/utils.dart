import 'dart:convert' as convert;
import 'dart:io';

import 'package:dart_style/dart_style.dart' show DartFormatter;

bool isValidClassName(String value) =>
    RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(value);

bool isValidLocale(String value) =>
    RegExp(r'^[a-z]{2,3}(_[A-Z][a-z]{3})?(_([A-Z]{2}|[0-9]{3}))?$')
        .hasMatch(value);

bool isValidPath(String value) =>
    RegExp(r'^(?:[A-Za-z]:)?([\/\\]{0,2}\w*)+$').hasMatch(value);

bool isValidDownloadEmptyAsParam(String value) =>
    RegExp(r'^(empty|main|skip)$').hasMatch(value);

bool isLangScriptCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_[A-Z][a-z]{3}_([A-Z]{2}|[0-9]{3})$').hasMatch(locale);

bool isLangScriptLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_[A-Z][a-z]{3}$').hasMatch(locale);

bool isLangCountryLocale(String locale) =>
    RegExp(r'^[a-z]{2,3}_([A-Z]{2}|[0-9]{3})$').hasMatch(locale);

void info(String message) => stdout.writeln('INFO: $message');

void warning(String message) => stdout.writeln('WARNING: $message');

void error(String message) => stderr.writeln('ERROR: $message');

void exitWithError(String message) {
  error(message);
  exit(2);
}

/// Convert to inline json message.
String formatJsonMessage(String jsonMessage) {
  var decoded = convert.jsonDecode(jsonMessage);
  return convert.jsonEncode(decoded);
}

/// Formats Dart file content.
String formatDartContent(String content, String fileName) {
  try {
    var formatter =
        DartFormatter(languageVersion: DartFormatter.latestLanguageVersion);
    return formatter.format(content);
  } catch (e) {
    info('Failed to format \'$fileName\' file.');
    return content;
  }
}
