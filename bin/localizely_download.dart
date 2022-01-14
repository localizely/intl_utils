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
  late String? projectId;
  late String? apiToken;
  late String arbDir;
  late String downloadEmptyAs;
  late List<String>? downloadIncludeTags;
  late List<String>? downloadExcludeTags;
  late String? branch;

  final argParser = args.ArgParser();

  try {
    final pubspecConfig = PubspecConfig();
    final credentialsConfig = CredentialsConfig();

    argParser
      ..addFlag(
        'help',
        abbr: 'h',
        help: 'Print this usage information.',
        negatable: false,
        defaultsTo: false,
      )
      ..addOption(
        'project-id',
        help: 'Localizely project ID.',
        callback: ((x) => projectId = x),
        defaultsTo: pubspecConfig.localizelyConfig?.projectId,
      )
      ..addOption(
        'api-token',
        help: 'Localizely API token.',
        callback: ((x) => apiToken = x),
      )
      ..addOption(
        'arb-dir',
        help: 'Directory of the arb files.',
        callback: ((x) => arbDir = x!),
        defaultsTo: pubspecConfig.arbDir ?? defaultArbDir,
      )
      ..addOption(
        'branch',
        help:
            'Get it from the “Branches” page on the Localizely platform, in case branching is enabled and you want to use a non-main branch.',
        callback: ((x) => branch = x),
        defaultsTo: pubspecConfig.localizelyConfig?.branch,
      )
      ..addOption(
        'download-empty-as',
        help:
            "Config parameter 'download_empty_as' expects one of the following values: 'empty', 'main' or 'skip'.",
        callback: ((x) => downloadEmptyAs = x!),
        defaultsTo: pubspecConfig.localizelyConfig?.downloadEmptyAs ??
            defaultDownloadEmptyAs,
      )
      ..addMultiOption(
        'download-include-tags',
        help: 'Optional list of tags to be downloaded.',
        callback: ((x) => downloadIncludeTags = x),
        defaultsTo: pubspecConfig.localizelyConfig?.downloadIncludeTags,
      )
      ..addMultiOption(
        'download-exclude-tags',
        help: 'Optional list of tags to be excluded from download.',
        callback: ((x) => downloadExcludeTags = x),
        defaultsTo: pubspecConfig.localizelyConfig?.downloadExcludeTags,
      );

    final argResults = argParser.parse(arguments);
    if (argResults['help'] == true) {
      stdout.writeln(argParser.usage);
      exit(0);
    }

    if (projectId == null) {
      throw ConfigException(
          "Argument 'project-id' was not provided, nor 'project_id' config was set within the 'flutter_intl/localizely' section of the 'pubspec.yaml' file.");
    }

    apiToken ??= credentialsConfig.apiToken;
    if (apiToken == null) {
      throw ConfigException(
          "Argument 'api-token' was not provided, nor 'api_token' config was set within the '${getLocalizelyCredentialsFilePath()}' file.");
    }

    if (!isValidDownloadEmptyAsParam(downloadEmptyAs)) {
      throw ConfigException(
        "Config parameter 'download_empty_as' expects one of the following values: 'empty', 'main' or 'skip'.",
      );
    }

    await LocalizelyService.download(projectId!, apiToken!, arbDir,
        downloadEmptyAs, branch, downloadIncludeTags, downloadExcludeTags);
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
