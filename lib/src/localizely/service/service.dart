import '../../utils/file_utils.dart';
import '../api/api.dart';
import 'service_exception.dart';

class LocalizelyService {
  LocalizelyService._();

  /// Uploads main ARB file on Localizely.
  static Future<void> uploadMainArbFile(
    String projectId,
    String apiToken,
    String arbPath,
    String mainLocale,
    String? branch,
    bool uploadOverwrite,
    bool uploadAsReviewed,
  ) async {
    final mainArbFile = getArbFileForLocale(mainLocale, arbPath);
    if (mainArbFile == null) {
      throw ServiceException("Can't find ARB file for the main locale.");
    }

    await LocalizelyApi.upload(
      projectId,
      apiToken,
      mainLocale,
      mainArbFile,
      branch,
      uploadOverwrite,
      uploadAsReviewed,
    );
  }

  /// Downloads all ARB files from Localizely.
  static Future<void> download(
    String projectId,
    String apiToken,
    String arbDir,
    String exportEmptyAs,
    String? branch,
  ) async {
    final response = await LocalizelyApi.download(
      projectId,
      apiToken,
      branch,
      exportEmptyAs,
    );

    for (var fileData in response.files) {
      await updateArbFile(
        fileData.name,
        fileData.bytes,
        arbDir,
      );
    }
  }
}
