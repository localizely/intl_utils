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
      [String? branch,
      bool overwrite = false,
      bool reviewed = false,
      List<String>? tagAdded,
      List<String>? tagUpdated,
      List<String>? tagRemoved]) async {
    var queryParams = [
      '?lang_code=$langCode',
      '&overwrite=$overwrite',
      '&reviewed=$reviewed',
      branch != null ? '&branch=$branch' : '',
      tagAdded != null
          ? tagAdded.map((tag) => '&tag_added=$tag').toList().join()
          : '',
      tagUpdated != null
          ? tagUpdated.map((tag) => '&tag_updated=$tag').toList().join()
          : '',
      tagRemoved != null
          ? tagRemoved.map((tag) => '&tag_removed=$tag').toList().join()
          : ''
    ].join();

    var uri =
        Uri.parse('$_baseUrl/v1/projects/$projectId/files/upload$queryParams');
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
      [String? branch,
      String? exportEmptyAs,
      List<String>? includeTags,
      List<String>? excludeTags]) async {
    var queryParams = [
      '?type=flutter_arb',
      branch != null ? '&branch=$branch' : '',
      exportEmptyAs != null ? '&export_empty_as=$exportEmptyAs' : '',
      includeTags != null
          ? includeTags.map((tag) => '&include_tags=$tag').toList().join()
          : '',
      excludeTags != null
          ? excludeTags.map((tag) => '&exclude_tags=$tag').toList().join()
          : ''
    ].join();

    var uri = Uri.parse(
        '$_baseUrl/v1/projects/$projectId/files/download$queryParams');
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
