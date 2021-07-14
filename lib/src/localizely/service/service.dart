import '../../utils/file_utils.dart';
import '../api/api.dart';
import 'service_exception.dart';

class LocalizelyService {
  LocalizelyService._();

  /// Uploads main ARB file on Localizely.
  static Future<void> uploadMainArbFile(
      String projectId,
      String apiToken,
      String arbDir,
      String mainLocale,
      String? branch,
      bool overwrite,
      bool reviewed,
      List<String>? tagAdded,
      List<String>? tagUpdated,
      List<String>? tagRemoved) async {
    final mainArbFile = getArbFileForLocale(mainLocale, arbDir);
    if (mainArbFile == null) {
      throw ServiceException("Can't find ARB file for the main locale.");
    }

    await LocalizelyApi.upload(projectId, apiToken, mainLocale, mainArbFile,
        branch, overwrite, reviewed, tagAdded, tagUpdated, tagRemoved);
  }

  /// Downloads all ARB files from Localizely.
  static Future<void> download(
    String projectId,
    String apiToken,
    String arbDir,
    String exportEmptyAs,
    String? branch,
    List<String>? includeTags,
    List<String>? excludeTags,
  ) async {
    final response = await LocalizelyApi.download(
        projectId, apiToken, branch, exportEmptyAs, includeTags, excludeTags);

    for (var fileData in response.files) {
      await updateArbFile(
        fileData.name,
        fileData.bytes,
        arbDir,
      );
    }
  }
}
