import 'package:yaml/yaml.dart' as yaml;

import '../utils/file_utils.dart';
import 'config_exception.dart';

class PubspecConfig {
  bool? _enabled;
  String? _className;
  String? _mainLocale;
  String? _arbDir;
  String? _outputDir;
  bool? _useDeferredLoading;
  LocalizelyConfig? _localizelyConfig;

  PubspecConfig() {
    var pubspecFile = getPubspecFile();
    if (pubspecFile == null) {
      throw ConfigException("Can't find 'pubspec.yaml' file.");
    }

    var pubspecFileContent = pubspecFile.readAsStringSync();
    var pubspecYaml = yaml.loadYaml(pubspecFileContent);

    var flutterIntlConfig = pubspecYaml['flutter_intl'];
    if (flutterIntlConfig == null) {
      return;
    }

    _enabled = flutterIntlConfig['enabled'] is bool
        ? flutterIntlConfig['enabled']
        : null;
    _className = flutterIntlConfig['class_name'] is String
        ? flutterIntlConfig['class_name']
        : null;
    _mainLocale = flutterIntlConfig['main_locale'] is String
        ? flutterIntlConfig['main_locale']
        : null;
    _arbDir = flutterIntlConfig['arb_dir'] is String
        ? flutterIntlConfig['arb_dir']
        : null;
    _outputDir = flutterIntlConfig['output_dir'] is String
        ? flutterIntlConfig['output_dir']
        : null;
    _useDeferredLoading = flutterIntlConfig['use_deferred_loading'] is bool
        ? flutterIntlConfig['use_deferred_loading']
        : null;
    _localizelyConfig =
        LocalizelyConfig.fromConfig(flutterIntlConfig['localizely']);
  }

  bool? get enabled => _enabled;

  String? get className => _className;

  String? get mainLocale => _mainLocale;

  String? get arbDir => _arbDir;

  String? get outputDir => _outputDir;

  bool? get useDeferredLoading => _useDeferredLoading;

  LocalizelyConfig? get localizelyConfig => _localizelyConfig;
}

class LocalizelyConfig {
  String? _projectId;
  String? _branch;
  bool? _uploadAsReviewed;
  bool? _uploadOverwrite;
  String? _downloadEmptyAs;
  bool? _otaEnabled;

  LocalizelyConfig.fromConfig(yaml.YamlMap? localizelyConfig) {
    if (localizelyConfig == null) {
      return;
    }

    _projectId = localizelyConfig['project_id'] is String
        ? localizelyConfig['project_id']
        : null;
    _branch = localizelyConfig['branch'] is String
        ? localizelyConfig['branch']
        : null;
    _uploadAsReviewed = localizelyConfig['upload_as_reviewed'] is bool
        ? localizelyConfig['upload_as_reviewed']
        : null;
    _uploadOverwrite = localizelyConfig['upload_overwrite'] is bool
        ? localizelyConfig['upload_overwrite']
        : null;
    _downloadEmptyAs = localizelyConfig['download_empty_as'] is String
        ? localizelyConfig['download_empty_as']
        : null;
    _otaEnabled = localizelyConfig['ota_enabled'] is bool
        ? localizelyConfig['ota_enabled']
        : null;
  }

  String? get projectId => _projectId;

  String? get branch => _branch;

  bool? get uploadAsReviewed => _uploadAsReviewed;

  bool? get uploadOverwrite => _uploadOverwrite;

  String? get downloadEmptyAs => _downloadEmptyAs;

  bool? get otaEnabled => _otaEnabled;
}
