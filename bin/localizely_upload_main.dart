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
  late String mainLocale;
  late String? branch;
  late bool uploadOverwrite;
  late bool uploadAsReviewed;
  late List<String>? uploadTagAdded;
  late List<String>? uploadTagUpdated;
  late List<String>? uploadTagRemoved;

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
        'main-locale',
        help:
            "Optional. Sets the main locale used for generating localization files. Provided value should consist of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN')",
        callback: ((x) => mainLocale = x!),
        defaultsTo: pubspecConfig.mainLocale ?? defaultMainLocale,
      )
      ..addOption(
        'branch',
        help:
            'Get it from the “Branches” page on the Localizely platform, in case branching is enabled and you want to use a non-main branch.',
        callback: ((x) => branch = x),
        defaultsTo: pubspecConfig.localizelyConfig?.branch,
      )
      ..addFlag(
        'upload-overwrite',
        help: 'Set to true if you want to overwrite translations with upload.',
        callback: ((x) => uploadOverwrite = x),
        defaultsTo: pubspecConfig.localizelyConfig?.uploadOverwrite ??
            defaultUploadOverwrite,
      )
      ..addFlag(
        'upload-as-reviewed',
        help:
            'Set to true if you want to mark uploaded translations as reviewed.',
        callback: ((x) => uploadAsReviewed = x),
        defaultsTo: pubspecConfig.localizelyConfig?.uploadAsReviewed ??
            defaultUploadAsReviewed,
      )
      ..addMultiOption(
        'upload-tag-added',
        help: 'Optional list of tags to add to new translations with upload.',
        callback: ((x) => uploadTagAdded = x),
        defaultsTo: pubspecConfig.localizelyConfig?.uploadTagAdded,
      )
      ..addMultiOption(
        'upload-tag-updated',
        help:
            'Optional list of tags to add to updated translations with upload.',
        callback: ((x) => uploadTagUpdated = x),
        defaultsTo: pubspecConfig.localizelyConfig?.uploadTagUpdated,
      )
      ..addMultiOption(
        'upload-tag-removed',
        help:
            'Optional list of tags to add to removed translations with upload.',
        callback: ((x) => uploadTagRemoved = x),
        defaultsTo: pubspecConfig.localizelyConfig?.uploadTagRemoved,
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

    if (!isValidLocale(mainLocale)) {
      throw ConfigException(
        "Config parameter 'main_locale' requires value consisted of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN').",
      );
    }

    await LocalizelyService.uploadMainArbFile(
        projectId!,
        apiToken!,
        arbDir,
        mainLocale,
        branch,
        uploadOverwrite,
        uploadAsReviewed,
        uploadTagAdded,
        uploadTagUpdated,
        uploadTagRemoved);
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
