import 'package:yaml/yaml.dart' as yaml;

import './config_exception.dart';
import '../utils/file_utils.dart';

class CredentialsConfig {
  String? _apiToken;

  CredentialsConfig() {
    var credentialsFile = getLocalizelyCredentialsFile();
    if (credentialsFile == null) {
      return;
    }

    var credentialsFileContent = credentialsFile.readAsStringSync();
    var credentialsYaml = yaml.loadYaml(credentialsFileContent);
    if (credentialsYaml is! yaml.YamlMap) {
      throw ConfigException(
          "Failed to extract 'api_token' from the '${getLocalizelyCredentialsFilePath()}' file.\nExpected YAML map (e.g. api_token: xxxxxx) but got ${credentialsYaml.runtimeType}.");
    }

    _apiToken = credentialsYaml['api_token'] is String
        ? credentialsYaml['api_token']
        : null;
  }

  String? get apiToken => _apiToken;
}
