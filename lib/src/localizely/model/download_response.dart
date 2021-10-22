import 'package:archive/archive.dart';
import 'package:http/http.dart';

import 'file_data.dart';

class DownloadResponse {
  late List<FileData> files;

  DownloadResponse.fromResponse(Response response) {
    files = [];

    var headers = response.headers;

    var contentDisposition = headers['content-disposition'];
    if (contentDisposition == null) {
      throw Exception("Missing 'Content-Disposition' header.");
    }

    var fileName = _getFileName(contentDisposition);
    if (fileName == null) {
      throw Exception(
          "Can't extract file name from 'Content-Disposition' header.");
    }

    var bytes = response.bodyBytes;

    var isArchive = _checkIsArchive(fileName);
    if (isArchive) {
      var archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        files.add(FileData(file.name, file.content));
      }
    } else {
      files.add(FileData(fileName, bytes));
    }
  }

  String? _getFileName(String contentDisposition) {
    var patterns = [
      RegExp('filename\\*=[^\']+\'\\w*\'"([^"]+)";?', caseSensitive: false),
      RegExp('filename\\*=[^\']+\'\\w*\'([^;]+);?', caseSensitive: false),
      RegExp('filename="([^;]*);?"', caseSensitive: false),
      RegExp('filename=([^;]*);?', caseSensitive: false)
    ];

    String? fileName;
    for (var i = 0; i < patterns.length; i++) {
      var allMatches = patterns[i].allMatches(contentDisposition);
      if (allMatches.isNotEmpty && allMatches.elementAt(0).groupCount == 1) {
        fileName = allMatches.elementAt(0).group(1);
        break;
      }
    }

    return fileName;
  }

  bool _checkIsArchive(String fileName) => fileName.endsWith('.zip');
}
