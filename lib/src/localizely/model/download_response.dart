import 'package:archive/archive.dart';
import 'package:http/http.dart';

import 'file_data.dart';

class DownloadResponse {
  List<FileData> files;

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

  String _getFileName(String contentDisposition) {
    var fileName;

    var fileNameChunkRegExp = RegExp(
        'filename[^;=\n]*=(([\'"]).*?\2|[^;\n]*)'); // may fail to detect ext. if file name contains `;` char
    var fileNameChunk = fileNameChunkRegExp.stringMatch(contentDisposition);
    if (fileNameChunk != null) {
      fileName = fileNameChunk.substring(
          'filename="'.length, fileNameChunk.length - '"'.length);
    }

    return fileName;
  }

  bool _checkIsArchive(String fileName) => fileName.endsWith('.zip');
}
