import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;

class FileUtils {
  // Assume that the current directory is the root of the project.
  static Directory getRootDirectory() {
    return Directory.current;
  }

  static File getPubspecFile() {
    var files = getRootDirectory().listSync();
    return files.firstWhere((fileEntity) => (fileEntity is File) && (path.basename(fileEntity.path) == 'pubspec.yaml'),
        orElse: () => null);
  }

  static File getArbFileForLocale(String locale) {
    var arbFilePath = path.join(getRootDirectory().path, 'lib', 'l10n', 'intl_$locale.arb');
    var arbFile = File(arbFilePath);

    return arbFile.existsSync() ? arbFile : null;
  }

  static void updateArbFile(String fileName, Uint8List bytes) async {
    var arbFilePath = path.join(getRootDirectory().path, 'lib', 'l10n', fileName);
    var arbFile = File(arbFilePath);

    if (!arbFile.existsSync()) {
      await arbFile.create();
    }

    await arbFile.writeAsBytes(bytes);
  }
}
