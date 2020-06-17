library intl_utils;

import 'dart:io';

import 'package:args/args.dart' as args;

import 'package:intl_utils/src/config/config.dart';
import 'package:intl_utils/src/config/config_exception.dart';
import 'package:intl_utils/src/localizely/api/api_exception.dart';
import 'package:intl_utils/src/localizely/service/service.dart';
import 'package:intl_utils/src/localizely/service/service_exception.dart';
import 'package:intl_utils/src/utils/utils.dart';
import 'package:intl_utils/src/utils/file_utils.dart';

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

  try {
    final argResults = argParser.parse(arguments);
    if (argResults['help'] == true) {
      stdout.writeln(argParser.usage);
      exit(0);
    }

    var projectId = argResults['project-id'] as String;
    var apiToken = argResults['api-token'] as String;

    if (projectId == null) {
      var pubspecConfig = Config.getPubspecConfig();
      projectId = pubspecConfig?.localizelyConfig?.projectId;

      if (projectId == null) {
        throw ConfigException(
            "Argument 'project-id' was not provided, nor 'project_id' config was set within the 'flutter_intl/localizely' section of the 'pubspec.yaml' file.");
      }
    }

    if (apiToken == null) {
      var localizelyCredentials = Config.getLocalizelyCredentials();
      apiToken = localizelyCredentials?.apiToken;

      if (apiToken == null) {
        throw ConfigException(
            "Argument 'api-token' was not provided, nor 'api_token' config was set within the '${FileUtils.getLocalizelyCredentialsFilePath()}' file.");
      }
    }

    await LocalizelyService.download(projectId, apiToken);
  } on args.ArgParserException catch (e) {
    exitWithError('${e.message}\n\n${argParser.usage}');
  } on ConfigException catch (e) {
    exitWithError(e.message);
  } on ServiceException catch (e) {
    exitWithError(e.message);
  } on ApiException catch (e) {
    exitWithError(e.getFormattedMessage());
  } catch (e) {
    exitWithError('Failed to download ARB files from Localizely.\n$e');
  }
}
