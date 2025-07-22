import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

import '../config/pubspec_config.dart';
import '../constants/constants.dart';
import '../generator/generator.dart';
import '../utils/file_utils.dart';
import '../utils/utils.dart';
import 'key_visitor.dart';
import 'unused_exception.dart';

/// Class for finding unused keys in the localization files.
/// This class analyzes the specified Dart class for keys and checks their usage across the project.
class Unused {
  late String _className;
  late String _outputDir;
  late String _arbDir;

  /// Creates a new instance with configuration from the 'pubspec.yaml' file.
  Unused() {
    final pubspecConfig = PubspecConfig();

    _className = defaultClassName;
    if (pubspecConfig.className != null) {
      if (isValidClassName(pubspecConfig.className!)) {
        _className = pubspecConfig.className!;
      } else {
        warning(
            "Config parameter 'class_name' requires a valid 'UpperCamelCase' value.");
      }
    }

    _outputDir = defaultOutputDir;
    if (pubspecConfig.outputDir != null) {
      if (isValidPath(pubspecConfig.outputDir!)) {
        _outputDir = pubspecConfig.outputDir!;
      } else {
        warning(
            "Config parameter 'output_dir' requires a valid path value (e.g., 'lib', 'res/', 'lib\\l10n').");
      }
    }

    _arbDir = defaultArbDir;
    if (pubspecConfig.arbDir != null) {
      if (isValidPath(pubspecConfig.arbDir!)) {
        _arbDir = pubspecConfig.arbDir!;
      } else {
        warning(
            "Config parameter 'arb_dir' requires valid path value (e.g. 'lib', 'res/', 'lib\\l10n').");
      }
    }
  }

  /// Finds unused keys in the specified Dart class.
  /// Analyzes all Dart files in the project to determine which keys are not used.
  Future<void> findUnusedAsync({
    bool saveToFile = false,
    bool clean = false,
    bool forceClean = false,
    bool noRegenerate = false,
  }) async {
    final l10nDartFilePath = getL10nDartFilePath(_outputDir);

    if (!File(l10nDartFilePath).existsSync()) {
      throw UnusedException('The file $l10nDartFilePath does not exist.');
    }

    final keys = _getKeys(l10nDartFilePath, _className);
    final allFiles = _getDartFiles();

    final allCodeBuffer = StringBuffer();
    int processedFiles = 0;
    final totalFiles = allFiles.length;

    for (final file in allFiles) {
      allCodeBuffer.write(File(file.path).readAsStringSync());
      processedFiles++;
      _showProgress(processedFiles, totalFiles, 'Reading project files');
    }

    final allCode = allCodeBuffer.toString();

    processedFiles = 0;
    final unusedKeys = <String>[];
    for (final key in keys) {
      final regex = RegExp(
          r'\b' +
              _className +
              r'\s*\.\s*(current|of\(.*?\))\s*\.\s*' +
              key +
              r'\b',
          multiLine: true);
      if (!regex.hasMatch(allCode)) {
        unusedKeys.add(key);
      }
      processedFiles++;
      _showProgress(processedFiles, keys.length, 'Checking keys');
    }

    info(
        'Found ${unusedKeys.length} unused keys out of ${keys.length} in ${allFiles.length} files');

    if (saveToFile) {
      await _saveUnusedKeysToFile(unusedKeys);
    }

    if (forceClean) {
      await _cleanUnusedKeys(unusedKeys);
      if (!noRegenerate) {
        await _regenerateFiles();
      }
    } else if (clean) {
      await _confirmAndCleanUnusedKeys(unusedKeys, noRegenerate);
    }
  }

  List<String> _getKeys(String filePath, String className) {
    final file = File(filePath);
    final code = file.readAsStringSync();
    final result = parseString(content: code);

    final visitor = KeyVisitor(className);
    result.unit.visitChildren(visitor);

    return visitor.keys;
  }

  List<FileSystemEntity> _getDartFiles() {
    final globPattern = Glob("lib/**.dart");
    return globPattern.listSync(followLinks: false);
  }

  Future<void> _saveUnusedKeysToFile(List<String> unusedKeys) async {
    final file = File('unused_keys.txt');
    final sink = file.openWrite();
    for (final key in unusedKeys) {
      sink.writeln(key);
    }
    await sink.close();
  }

  Future<void> _confirmAndCleanUnusedKeys(
    List<String> unusedKeys,
    bool noRegenerate,
  ) async {
    stdout.writeln(
        'This operation will remove ${unusedKeys.length} unused keys from the original .arb files.');
    stdout.write('Do you want to proceed? (y/n): ');
    final response = stdin.readLineSync();
    if (response?.toLowerCase() == 'y') {
      await _cleanUnusedKeys(unusedKeys);
      if (!noRegenerate) {
        await _regenerateFiles();
      }
    } else {
      stdout.writeln('Operation cancelled.');
    }
  }

  Future<void> _cleanUnusedKeys(List<String> unusedKeys) async {
    final arbFiles = getArbFiles(_arbDir).map((file) => file.path).toList();
    final jsonDecoder = JsonDecoder();
    final jsonEncoder = JsonEncoder.withIndent('  ');

    for (final arbFile in arbFiles) {
      final file = File(arbFile);
      final content = await file.readAsString();
      final map = jsonDecoder.convert(content) as Map<String, dynamic>;

      int removedKeysCount = 0;
      for (final key in unusedKeys) {
        if (map.containsKey(key)) {
          map.remove(key);
          map.remove('@$key'); // Remove associated metadata
          removedKeysCount++;
        }
      }

      if (removedKeysCount > 0) {
        final updatedContent = jsonEncoder.convert(map);
        await file.writeAsString(updatedContent);
        info('Removed $removedKeysCount unused keys from ${file.path}');
      }
    }
  }

  Future<void> _regenerateFiles() async {
    final generator = Generator();
    await generator.generateAsync();
    info('Regenerated localization files.');
  }

  void _showProgress(int current, int total, String phase) {
    final progress = (current / total * 100).toStringAsFixed(1);
    stdout.write('\r$phase: $progress% ($current/$total)');
    if (current == total) {
      stdout.writeln();
    }
  }
}
