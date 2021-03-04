import 'package:yaml/yaml.dart' as yaml;

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

    _apiToken = credentialsYaml['api_token'] is String
        ? credentialsYaml['api_token']
        : null;
  }

  String? get apiToken => _apiToken;
}
