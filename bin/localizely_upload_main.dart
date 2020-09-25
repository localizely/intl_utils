library intl_utils;

import 'dart:io';

import 'package:args/args.dart' as args;
import 'package:intl_utils/src/config/config_exception.dart';
import 'package:intl_utils/src/config/credentials_config.dart';
import 'package:intl_utils/src/config/pubspec_config.dart';
import 'package:intl_utils/src/constants/constants.dart';
import 'package:intl_utils/src/localizely/api/api_exception.dart';
import 'package:intl_utils/src/localizely/service/service.dart';
import 'package:intl_utils/src/localizely/service/service_exception.dart';
import 'package:intl_utils/src/utils/file_utils.dart';
import 'package:intl_utils/src/utils/utils.dart';

Future<void> main(List<String> arguments) async {
  final argParser = args.ArgParser();
  argParser.addFlag(
    'help',
    abbr: 'h',
    defaultsTo: false,
    negatable: false,
    help: 'Print this usage information.',
  );
  argParser.addOption(
    'project-id',
    help: 'Localizely project ID.',
  );
  argParser.addOption(
    'api-token',
    help: 'Localizely API token.',
  );
  argParser.addOption(
    'arb-dir',
    help: 'Path of the arb files.',
    defaultsTo: defaultArbDir,
  );

  try {
    final argResults = argParser.parse(arguments);
    if (argResults['help'] == true) {
      stdout.writeln(argParser.usage);
      exit(0);
    }

    var projectId = argResults['project-id'] as String;
    var apiToken = argResults['api-token'] as String;
    var arbDir = argResults['arb-dir'] as String;

    if (projectId == null) {
      var pubspecConfig = PubspecConfig();
      projectId = pubspecConfig.localizelyConfig?.projectId;

      if (projectId == null) {
        throw ConfigException(
            "Argument 'project-id' was not provided, nor 'project_id' config was set within the 'flutter_intl/localizely' section of the 'pubspec.yaml' file.");
      }
    }

    if (apiToken == null) {
      var credentialsConfig = CredentialsConfig();
      apiToken = credentialsConfig.apiToken;

      if (apiToken == null) {
        throw ConfigException(
            "Argument 'api-token' was not provided, nor 'api_token' config was set within the '${getLocalizelyCredentialsFilePath()}' file.");
      }
    }

    await LocalizelyService.uploadMainArbFile(projectId, apiToken, arbDir);
  } on args.ArgParserException catch (e) {
    exitWithError('${e.message}\n\n${argParser.usage}');
  } on ConfigException catch (e) {
    exitWithError(e.message);
  } on ServiceException catch (e) {
    exitWithError(e.message);
  } on ApiException catch (e) {
    exitWithError(e.getFormattedMessage());
  } catch (e) {
    exitWithError('Failed to upload the main ARB file on Localizely.\n$e');
  }
}
