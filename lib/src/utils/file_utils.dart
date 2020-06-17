import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as path;

class FileUtils {
  FileUtils._();

  /// Gets the root directory of a project.
  ///
  /// Note: The current working directory is assumed to be the root of a project.
  static Directory getRootDirectory() {
    return Directory.current;
  }

  /// Gets the root directory path of a project.
  static String getRootDirectoryPath() {
    return getRootDirectory().path;
  }

  /// Gets the pubspec file of a project.
  static File getPubspecFile() {
    var files = getRootDirectory().listSync();
    return files.firstWhere(
        (fse) => (fse is File) && (path.basename(fse.path) == 'pubspec.yaml'),
        orElse: () => null);
  }

  /// Gets arb file for the given locale.
  static File getArbFileForLocale(String locale) {
    var rootDirPath = getRootDirectoryPath();
    var arbFilePath = path.join(rootDirPath, 'lib', 'l10n', 'intl_$locale.arb');
    var arbFile = File(arbFilePath);

    return arbFile.existsSync() ? arbFile : null;
  }

  /// Gets all arb files in the project.
  static List<FileSystemEntity> getArbFiles() {
    var l10nDirPath = path.join(getRootDirectoryPath(), 'lib', 'l10n');
    var arbFiles = Directory(l10nDirPath)
        .listSync()
        .where((file) =>
            path.basename(file.path).startsWith('intl_') &&
            path.basename(file.path).endsWith('.arb'))
        .toList();

    // arb files order is not the same on all operating systems (e.g. win, mac)
    arbFiles.sort((a, b) => a.path.compareTo(b.path));

    return arbFiles;
  }

  /// Gets all locales in the project.
  static List<String> getLocales() {
    var locales = getArbFiles()
        .map((file) => path.basename(file.path))
        .map((fileName) =>
            fileName.substring('intl_'.length, fileName.length - '.arb'.length))
        .toList();

    return locales;
  }

  /// Updates arb file content.
  static void updateArbFile(String fileName, Uint8List bytes) async {
    var rootDirPath = getRootDirectoryPath();
    var arbFilePath = path.join(rootDirPath, 'lib', 'l10n', fileName);
    var arbFile = File(arbFilePath);

    if (!arbFile.existsSync()) {
      await arbFile.create();
    }

    await arbFile.writeAsBytes(bytes);
  }

  /// Gets Localizely credentials file.
  static File getLocalizelyCredentialsFile() {
    var credentialsFilePath = getLocalizelyCredentialsFilePath();
    if (credentialsFilePath == null) {
      return null;
    }

    var credentialsFile = File(credentialsFilePath);

    return credentialsFile.existsSync() ? credentialsFile : null;
  }

  /// Gets Localizely credentials file path.
  static String getLocalizelyCredentialsFilePath() {
    var userHome = getUserHome();
    if (userHome == null) {
      return null;
    }

    return path.join(userHome, '.localizely', 'credentials.yaml');
  }

  /// Gets the user's home directory path.
  static String getUserHome() {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['HOME'];
    } else if (Platform.isWindows) {
      return Platform.environment['USERPROFILE'];
    } else {
      return null;
    }
  }
}
