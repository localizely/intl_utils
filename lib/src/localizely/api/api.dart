import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../../utils/utils.dart';
import '../api/api_exception.dart';
import '../model/download_response.dart';

class LocalizelyApi {
  static final String _baseUrl = 'https://api.localizely.com';

  LocalizelyApi._();

  static Future<void> upload(
      String projectId, String apiToken, String langCode, File file,
      [String? branch, bool overwrite = false, bool reviewed = false]) async {
    var branchParam = branch != null ? '&branch=${branch}' : '';

    var uri = Uri.parse(
        '$_baseUrl/v1/projects/$projectId/files/upload?lang_code=$langCode&overwrite=$overwrite&reviewed=$reviewed$branchParam');
    var headers = {'X-Api-Token': apiToken};

    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(http.MultipartFile.fromBytes('file', file.readAsBytesSync(),
          filename: path.basename(file.path)));

    var response = await request.send();

    if (response.statusCode != 200) {
      var formattedResponse =
          formatJsonMessage(await response.stream.bytesToString());
      throw ApiException('Failed to upload data on Localizely.',
          response.statusCode, formattedResponse);
    }
  }

  static Future<DownloadResponse> download(String projectId, String apiToken,
      [String? branch, String? exportEmptyAs]) async {
    var branchParam = branch != null ? '&branch=${branch}' : '';
    var exportEmptyAsParam =
        exportEmptyAs != null ? '&export_empty_as=${exportEmptyAs}' : '';

    var uri = Uri.parse(
        '$_baseUrl/v1/projects/$projectId/files/download?type=flutter_arb${branchParam}${exportEmptyAsParam}');
    var headers = {'X-Api-Token': apiToken};

    var response = await http.get(uri, headers: headers);

    if (response.statusCode != 200) {
      var formattedResponse = formatJsonMessage(response.body);
      throw ApiException('Failed to download data from Localizely.',
          response.statusCode, formattedResponse);
    }

    return DownloadResponse.fromResponse(response);
  }
}
