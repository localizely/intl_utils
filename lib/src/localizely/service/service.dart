import '../api/api.dart';
import '../../config/config.dart';
import '../../utils/file_utils.dart';
import '../../constants/constants.dart';
import '../../utils/utils.dart';
import 'service_exception.dart';

class LocalizelyService {

  LocalizelyService._();

  /// Upload main ARB file on Localizely.
  static Future<void> uploadMainArbFile(String projectId, String apiToken) async {
    var pubspecConfig = Config.getPubspecConfig();

    var mainLocale = pubspecConfig?.mainLocale;
    if (mainLocale != null) {
      var isValidLocale = validateLocale(mainLocale);
      if (!isValidLocale) {
        mainLocale = defaultMainLocale;
        warning("Config parameter 'main_locale' requires value consisted of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN').");
      }
    } else {
      mainLocale = defaultMainLocale;
    }

    var mainArbFile = FileUtils.getArbFileForLocale(mainLocale);
    if (mainArbFile == null) {
      throw ServiceException("Can't find ARB file for the main locale.");
    }

    var overwrite = pubspecConfig?.localizelyConfig?.uploadOverwrite ?? false;
    var reviewed = pubspecConfig?.localizelyConfig?.uploadAsReviewed ?? false;

    await LocalizelyApi.upload(projectId, apiToken, mainLocale, mainArbFile, overwrite, reviewed);
  }

  // Download all ARB files from Localizely.
  static Future<void> download(String projectId, String apiToken) async {
    var response = await LocalizelyApi.download(projectId, apiToken);

    for (var fileData in response.files) {
      await FileUtils.updateArbFile(fileData.name, fileData.bytes);
    }
  }
}
