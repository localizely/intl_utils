library intl_utils;

import 'dart:io';

import 'package:intl_utils/intl_utils.dart';
import 'package:intl_utils/src/utils.dart';

Future<void> main(List<String> args) async {
  try {
    var generator = Generator();
    await generator.generateAsync();
  } on GeneratorException catch (e) {
    error(e.message);
    exit(2);
  } catch (e) {
    error('Failed to generate localization files.');
    exit(2);
  }
}
