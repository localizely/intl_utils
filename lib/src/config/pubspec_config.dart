import 'package:yaml/yaml.dart' as yaml;

import '../utils/file_utils.dart';
import 'config_exception.dart';

class PubspecConfig {
  bool? _flutter = false;
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

    if (pubspecYaml is! yaml.YamlMap) {
      throw ConfigException(
          "Failed to extract config from the 'pubspec.yaml' file.\nExpected YAML map but got ${pubspecYaml.runtimeType}.");
    }

    var intlConfig = pubspecYaml['flutter_intl'];
    if (intlConfig == null) {
      intlConfig = pubspecYaml['intl'];

      if( intlConfig==null)
        throw ConfigException(
            "Failed to detect flutter or dart context: no 'flutter_intl' or 'intl' keys found into 'pubspec.yaml' file.");

      _flutter = false;
    } else
      _flutter = true;

    _enabled = intlConfig['enabled'] is bool
        ? intlConfig['enabled']
        : null;
    _className = intlConfig['class_name'] is String
        ? intlConfig['class_name']
        : null;
    _mainLocale = intlConfig['main_locale'] is String
        ? intlConfig['main_locale']
        : null;
    _arbDir = intlConfig['arb_dir'] is String
        ? intlConfig['arb_dir']
        : null;
    _outputDir = intlConfig['output_dir'] is String
        ? intlConfig['output_dir']
        : null;
    _useDeferredLoading = intlConfig['use_deferred_loading'] is bool
        ? intlConfig['use_deferred_loading']
        : null;
    _localizelyConfig =
        LocalizelyConfig.fromConfig(intlConfig['localizely']);
  }

  bool? get flutter => _flutter;

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
  List<String>? _uploadTagAdded;
  List<String>? _uploadTagUpdated;
  List<String>? _uploadTagRemoved;
  String? _downloadEmptyAs;
  List<String>? _downloadIncludeTags;
  List<String>? _downloadExcludeTags;
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
    _uploadTagAdded = localizelyConfig['upload_tag_added'] is yaml.YamlList
        ? List<String>.from(localizelyConfig['upload_tag_added'])
        : null;
    _uploadTagUpdated = localizelyConfig['upload_tag_updated'] is yaml.YamlList
        ? List<String>.from(localizelyConfig['upload_tag_updated'])
        : null;
    _uploadTagRemoved = localizelyConfig['upload_tag_removed'] is yaml.YamlList
        ? List<String>.from(localizelyConfig['upload_tag_removed'])
        : null;
    _downloadEmptyAs = localizelyConfig['download_empty_as'] is String
        ? localizelyConfig['download_empty_as']
        : null;
    _downloadIncludeTags =
        localizelyConfig['download_include_tags'] is yaml.YamlList
            ? List<String>.from(localizelyConfig['download_include_tags'])
            : null;
    _downloadExcludeTags =
        localizelyConfig['download_exclude_tags'] is yaml.YamlList
            ? List<String>.from(localizelyConfig['download_exclude_tags'])
            : null;
    _otaEnabled = localizelyConfig['ota_enabled'] is bool
        ? localizelyConfig['ota_enabled']
        : null;
  }

  String? get projectId => _projectId;

  String? get branch => _branch;

  bool? get uploadAsReviewed => _uploadAsReviewed;

  bool? get uploadOverwrite => _uploadOverwrite;

  List<String>? get uploadTagAdded => _uploadTagAdded;

  List<String>? get uploadTagUpdated => _uploadTagUpdated;

  List<String>? get uploadTagRemoved => _uploadTagRemoved;

  String? get downloadEmptyAs => _downloadEmptyAs;

  List<String>? get downloadIncludeTags => _downloadIncludeTags;

  List<String>? get downloadExcludeTags => _downloadExcludeTags;

  bool? get otaEnabled => _otaEnabled;
}
