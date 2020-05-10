import 'dart:io';
import 'dart:convert';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' as yaml;

import 'label.dart';
import 'templates.dart';
import 'intl_translation_helper.dart';
import '../utils/utils.dart';
import '../utils/file_utils.dart';
import '../constants/constants.dart';

class Generator {
  Directory rootDir;
  String className;
  String mainLocale;
  bool otaEnabled;

  Generator() {
    rootDir = Directory.current;
  }

  Future<void> generateAsync() async {
    var pubspecFile = FileUtils.getPubspecFile();
    if (pubspecFile == null) {
      throw GeneratorException("Can't find 'pubspec.yaml' file.");
    }

    _updateConfig(pubspecFile);

    await _updateL10nDir();
    await _updateGeneratedDir();
    await _generateDartFiles();
  }

  /// Update generator config with the config values from the 'pubspec.yaml' file.
  /// Note: Current implementation ignores 'enabled' config property from the 'pubspec.yaml' file.
  void _updateConfig(File pubspecFile) {
    var content = pubspecFile.readAsStringSync();
    var pubspecYaml = yaml.loadYaml(content);

    var config = pubspecYaml['flutter_intl'];
    var className = config != null ? config['class_name'] : null;
    if (className != null) {
      var isValid = validateClassName(className);
      if (isValid) {
        this.className = className;
      } else {
        warning("Config parameter 'class_name' requires valid 'UpperCamelCase' value.");
      }
    }

    var mainLocale = config != null ? config['main_locale'] : null;
    if (mainLocale != null) {
      var isValid = validateLocale(mainLocale);
      if (isValid) {
        this.mainLocale = mainLocale;
      } else {
        warning("Config parameter 'main_locale' requires value consisted of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN').");
      }
    }

    var otaEnabled = config != null && config['localizely'] != null ? config['localizely']['ota_enabled'] : null;
    if (otaEnabled != null) {
      var isValid = otaEnabled is bool;
      if (isValid) {
        this.otaEnabled = otaEnabled;
      } else {
        warning("Config parameter 'ota_enabled' requires boolean value.");
      }
    }
  }

  Future<void> _updateL10nDir() async {
    var mainLocale = this.mainLocale ?? defaultMainLocale;
    var mainArbFilePath = path.join(rootDir.path, 'lib', 'l10n', 'intl_${mainLocale}.arb');
    var mainArbFile = File(mainArbFilePath);

    if (!mainArbFile.existsSync()) {
      await mainArbFile.create(recursive: true);
      await mainArbFile.writeAsString('{}');
    }
  }

  Future<void> _updateGeneratedDir() async {
    var l10nDartFilePath = path.join(rootDir.path, 'lib', 'generated', 'l10n.dart');
    var l10nDartFile = File(l10nDartFilePath);

    if (!l10nDartFile.existsSync()) {
      await l10nDartFile.create(recursive: true);
    }

    var className = this.className ?? defaultClassName;
    var labels = _getLabelsFromMainArbFile();
    var locales = _orderAvailableLocales(_getAvailableLocales());
    var otaEnabled = this.otaEnabled ?? defaultOtaEnabled;
    var content = generateL10nDartFileContent(className, labels, locales, otaEnabled);
    await l10nDartFile.writeAsString(content);

    var intlDirPath = path.join(rootDir.path, 'lib', 'generated', 'intl');
    var intlDir = await Directory(intlDirPath).create(recursive: true);

    // remove unused dart messages files
    var files = intlDir.listSync();
    for (var file in files) {
      var fileName = path.basename(file.path);
      if (fileName.startsWith('messages_') &&
          fileName.endsWith('.dart') &&
          !['all', ...locales].contains(fileName.substring(9, fileName.length - 5))) {
        await file.delete(recursive: true);
      }
    }
  }

  List<Label> _getLabelsFromMainArbFile() {
    var mainLocale = this.mainLocale ?? defaultMainLocale;
    var mainArbFilePath = path.join(rootDir.path, 'lib', 'l10n', 'intl_${mainLocale}.arb');
    var mainArbFile = File(mainArbFilePath);
    var content = mainArbFile.readAsStringSync();
    var decodedContent = json.decode(content) as Map<String, dynamic>;

    var labels = decodedContent.keys.where((key) => !key.startsWith('@')).map((key) {
      var name = key;
      var content = decodedContent[key];

      var meta = decodedContent['@$key'];
      var type = meta != null && meta['type'] != null ? meta['type'] : null;
      var description = meta != null && meta['description'] != null ? meta['description'] : null;
      var placeholders = meta != null && meta['placeholders'] != null
          ? (meta['placeholders'] as Map<String, dynamic>).keys.toList()
          : null;

      return Label(name, content, type: type, description: description, placeholders: placeholders);
    }).toList();

    return labels;
  }

  List<FileSystemEntity> _getAvailableArbFiles() {
    var arbFiles = Directory(path.join(rootDir.path, 'lib', 'l10n'))
        .listSync()
        .where((file) => path.basename(file.path).startsWith('intl_') && path.basename(file.path).endsWith('.arb'))
        .toList();

    arbFiles.sort((a, b) => a.path.compareTo(b.path)); // arb files order is not the same on all operating systems (e.g. win, mac)

    return arbFiles;
  }

  List<String> _getAvailableLocales() {
    return _getAvailableArbFiles()
        .map((file) => path.basename(file.path))
        .map((fileName) => fileName.substring('intl_'.length, fileName.length - '.arb'.length))
        .toList();
  }

  List<String> _orderAvailableLocales(List<String> locales) {
    var mainLocale = this.mainLocale ?? defaultMainLocale;

    var index = locales.indexOf(mainLocale);
    return index != -1
        ? [locales.elementAt(index), ...locales.sublist(0, index), ...locales.sublist(index + 1)]
        : locales;
  }

  Future<void> _generateDartFiles() async {
    var outputDir = path.join(rootDir.path, 'lib', 'generated', 'intl');
    var dartFiles = [path.join(rootDir.path, 'lib', 'generated', 'l10n.dart')];
    var arbFiles = _getAvailableArbFiles()
        .map((file) => file.path)
        .toList();

    // validate arb files (e.g. check if they are well-formatted, etc.)

    var helper = IntlTranslationHelper();
    helper.generateFromArb(outputDir, dartFiles, arbFiles);
  }
}

class GeneratorException implements Exception {
  final String message;

  GeneratorException([this.message]);

  @override
  String toString() {
    return 'GeneratorException: ${message ?? ""}';
  }
}
