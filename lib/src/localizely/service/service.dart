import '../../config/pubspec_config.dart';
import '../../constants/constants.dart';
import '../../utils/file_utils.dart';
import '../../utils/utils.dart';
import '../api/api.dart';
import 'service_exception.dart';

class LocalizelyService {
  LocalizelyService._();

  /// Uploads main ARB file on Localizely.
  static Future<void> uploadMainArbFile(
      String projectId, String apiToken, String arbPath) async {
    var pubspecConfig = PubspecConfig();

    var mainLocale = pubspecConfig.mainLocale;
    if (mainLocale != null) {
      if (!isValidLocale(mainLocale)) {
        mainLocale = defaultMainLocale;
        warning(
            "Config parameter 'main_locale' requires value consisted of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN').");
      }
    } else {
      mainLocale = defaultMainLocale;
    }

    var mainArbFile = getArbFileForLocale(mainLocale, arbPath);
    if (mainArbFile == null) {
      throw ServiceException("Can't find ARB file for the main locale.");
    }

    var branch = pubspecConfig.localizelyConfig?.branch;
    var overwrite = pubspecConfig.localizelyConfig?.uploadOverwrite ??
        defaultUploadOverwrite;
    var reviewed = pubspecConfig.localizelyConfig?.uploadAsReviewed ??
        defaultUploadAsReviewed;

    await LocalizelyApi.upload(projectId, apiToken, mainLocale, mainArbFile,
        branch, overwrite, reviewed);
  }

  /// Downloads all ARB files from Localizely.
  static Future<void> download(
      String projectId, String apiToken, String arbPath) async {
    var pubspecConfig = PubspecConfig();

    var branch = pubspecConfig.localizelyConfig?.branch;

    var response = await LocalizelyApi.download(projectId, apiToken, branch);

    for (var fileData in response.files) {
      await updateArbFile(fileData.name, fileData.bytes, arbPath);
    }
  }
}
