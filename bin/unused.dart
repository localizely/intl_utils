library intl_utils;

import 'package:intl_utils/src/unused/unused.dart';
import 'package:intl_utils/src/unused/unused_exception.dart';
import 'package:intl_utils/src/utils/utils.dart';

Future<void> main(List<String> args) async {
  try {
    var unused = Unused();

    final saveToFile = args.contains('--save');
    final clean = args.contains('--clean');
    final forceClean = args.contains('--force-clean');
    final noRegenerate = args.contains('--no-regenerate');
    await unused.findUnusedAsync(
      saveToFile: saveToFile,
      clean: clean,
      forceClean: forceClean,
      noRegenerate: noRegenerate,
    );
  } on UnusedException catch (e) {
    exitWithError(e.message);
  } catch (e) {
    exitWithError('Failed to find unused keys.\n$e');
  }
}
