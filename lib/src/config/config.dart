import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' as yaml;

import 'pubspec_config.dart';
import 'localizely_credentials.dart';
import '../utils/file_utils.dart';

class Config {
  static PubspecConfig getPubspecConfig() {
    var pubspecFile = FileUtils.getPubspecFile();
    if (pubspecFile == null) {
      return null;
    }

    var pubspecFileContent = pubspecFile.readAsStringSync();
    var pubspecYaml = yaml.loadYaml(pubspecFileContent);

    var flutterIntlConfig = pubspecYaml['flutter_intl'];
    if (flutterIntlConfig == null) {
      return null;
    }

    var enabled = _isBool(flutterIntlConfig['enabled']) ? flutterIntlConfig['enabled'] : null;
    var className = _isString(flutterIntlConfig['class_name']) ? flutterIntlConfig['class_name'] : null;
    var mainLocale = _isString(flutterIntlConfig['main_locale']) ? flutterIntlConfig['main_locale'] : null;

    var localizely = _isMap(flutterIntlConfig['localizely']) ? flutterIntlConfig['localizely'] : null;
    var localizelyConfig = localizely != null
        ? LocalizelyConfig(
            _isString(localizely['project_id']) ? localizely['project_id'] : null,
            _isBool(localizely['upload_as_reviewed']) ? localizely['upload_as_reviewed'] : null,
            _isBool(localizely['upload_overwrite']) ? localizely['upload_overwrite'] : null,
            _isBool(localizely['ota_enabled']) ? localizely['ota_enabled'] : null)
        : null;

    return PubspecConfig(enabled, className, mainLocale, localizelyConfig);
  }

  static LocalizelyCredentials getLocalizelyCredentials() {
    var userHome = getUserHome();
    if (userHome == null) {
      return null;
    }

    var credentialsFile = File(path.join(userHome, '.localizely', 'credentials.yaml'));
    if (!credentialsFile.existsSync()) {
      return null;
    }

    var credentialsFileContent = credentialsFile.readAsStringSync();
    var credentialsYaml = yaml.loadYaml(credentialsFileContent);

    var apiToken = _isString(credentialsYaml['api_token']) ? credentialsYaml['api_token'] : null;

    return LocalizelyCredentials(apiToken);
  }

  static String getUserHome() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['HOME'];
    } else if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'];
    } else {
      return null;
    }
  }

  static bool _isBool(Object value) {
    return (value is bool);
  }

  static bool _isString(Object value) {
    return (value is String);
  }

  static bool _isMap(Object value) {
    return (value is Map);
  }
}
