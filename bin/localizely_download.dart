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
  late bool usePubspec;
  late String? projectId;
  late String? apiToken;
  late String arbDir;
  late String exportEmptyAs;
  late String? branch;

  final argParser = args.ArgParser()
    ..addFlag(
      'use-pubspec',
      defaultsTo: true,
      help:
          'Set this flag to false in order to run the executable from command line instead of from a configured pubspec.yaml. Default: true',
      callback: ((x) => usePubspec = x),
    )
    ..addFlag(
      'help',
      abbr: 'h',
      defaultsTo: false,
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addOption(
      'project-id',
      help: 'Localizely project ID.',
      callback: ((x) => projectId = x),
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
      defaultsTo: defaultArbDir,
    )
    ..addOption(
      'branch',
      help:
          'Get it from the “Branches” page on the Localizely platform, in case branching is enabled and you want to use a non-main branch.',
      callback: ((x) => branch = x),
    )
    ..addOption(
      'download-empty-as',
      help: "Config parameter 'download_empty_as' expects one of the following values: 'empty', 'main' or 'skip'.",
      defaultsTo: defaultDownloadEmptyAs,
      callback: ((x) => exportEmptyAs = x!),
    );

  try {
    final argResults = argParser.parse(arguments);
    if (argResults['help'] == true) {
      stdout.writeln(argParser.usage);
      exit(0);
    }

    if (usePubspec) {
      final pubspecConfig = PubspecConfig();
      projectId = pubspecConfig.localizelyConfig?.projectId;
      apiToken = CredentialsConfig().apiToken;
      arbDir = pubspecConfig.arbDir ?? defaultArbDir;
      exportEmptyAs = pubspecConfig.localizelyConfig?.downloadEmptyAs ?? defaultDownloadEmptyAs;
      branch = pubspecConfig.localizelyConfig?.branch;
    }

    if (projectId == null) {
      throw ConfigException(
          "Argument 'project-id' was not provided, nor 'project_id' config was set within the 'flutter_intl/localizely' section of the 'pubspec.yaml' file.");
    }

    if (apiToken == null) {
      throw ConfigException(
          "Argument 'api-token' was not provided, nor 'api_token' config was set within the '${getLocalizelyCredentialsFilePath()}' file.");
    }

    if (!isValidDownloadEmptyAsParam(exportEmptyAs)) {
      throw ConfigException(
        "Config parameter 'download_empty_as' expects one of the following values: 'empty', 'main' or 'skip'.",
      );
    }

    await LocalizelyService.download(
      projectId!,
      apiToken!,
      arbDir,
      exportEmptyAs,
      branch,
    );
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
