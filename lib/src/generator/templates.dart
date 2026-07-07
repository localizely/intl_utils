import '../utils/utils.dart';
import 'label.dart';

String generateL10nDartFileContent(
    bool flutter,
    String className,
    List<Label> labels,
    List<String> locales, [
      bool otaEnabled = false
]) {
  var l10nContent = """
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';${flutter ? "\nimport 'package:flutter/widgets.dart';" : "\nimport 'package:intl/locale.dart';"}${otaEnabled ? '\n${_generateLocalizelySdkImport()}' : ''}

// **************************************************************************
// Generator: Dart/Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class $className {
  $className();

  static $className? _current;

  static $className get current {
    assert(_current != null, 'No instance of $className was loaded. Try to initialize the $className delegate before accessing $className.current.');
    return _current!;
  }

  static Future<$className> load(Locale locale) {
    return loadByLocaleBasis(locale.countryCode, locale.languageCode);
  }
  
  static Future<$className> loadByLocaleBasis(String? countryCode, String languageCode) {
    final name = countryCode == null || countryCode.isEmpty
        ? languageCode
        : languageCode + '_' + countryCode;
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = $className();
      $className._current = instance;

      return instance;
    });
  }
""";

  if (flutter) {
    l10nContent += """
  static const ${className}LocalizationDelegate delegate = ${className}LocalizationDelegate();
  
  static $className of(BuildContext context) {
    final instance = $className.maybeOf(context);
    assert(instance != null, 'No instance of $className present in the widget tree. Did you add $className.delegate in localizationsDelegates?');
    return instance!;
  }

  static $className? maybeOf(BuildContext context) {
    return Localizations.of<$className>(context, $className);
  }
""";
  }

  if (otaEnabled) {
    l10nContent += "\n${_generateMetadata(labels)}\n";
  }

  for (final label in labels) {
    l10nContent += "${label.generateDartGetter()}\n\n";
  }

  l10nContent += '}';
  //Localization messages class end

  if (flutter) {
    l10nContent += "\n\n${_generateLocalizationsDelegateClass(className, locales)}";
  }

  return l10nContent;
}

String generateL10FlutterLocalizationsDelegateExtension(String className, List<String> locales) {
  return """
//TODO enter your dart package with localized messages
import 'package:your_dart_package_with_localizations/filename.dart';
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/widgets.dart';

// **************************************************************************
// Generator: Flutter LocalizationsDelegate adaptor for Dart Intl IDE plugin
// Made by mIwr
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

extension ${className}ExtFlutter on $className {

  static const ${className}LocalizationDelegate delegate = ${className}LocalizationDelegate();

  static Future<$className> load(Locale locale) {
    return $className.loadByLocaleBasis(locale.countryCode, locale.languageCode);
  }

}

${_generateLocalizationsDelegateClass(className, locales)}
""";
}

String _generateLocalizationsDelegateClass(String intlClassName, List<String> locales) {
  return """
class ${intlClassName}LocalizationDelegate extends LocalizationsDelegate<$intlClassName> {
  const ${intlClassName}LocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
    ${locales.map((locale) => _generateLocale(locale)).join('\n')}
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<$intlClassName> load(Locale locale) => $intlClassName.loadByLocaleBasis(locale.countryCode, locale.languageCode);
  @override
  bool shouldReload(${intlClassName}LocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
""".trim();
}

String _generateLocale(String locale) {
  var parts = locale.split('_');

  if (isLangScriptCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\', countryCode: \'${parts[2]}\'),';
  } else if (isLangScriptLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', scriptCode: \'${parts[1]}\'),';
  } else if (isLangCountryLocale(locale)) {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\', countryCode: \'${parts[1]}\'),';
  } else {
    return '      Locale.fromSubtags(languageCode: \'${parts[0]}\'),';
  }
}

String _generateLocalizelySdkImport() {
  return "import 'package:localizely_sdk/localizely_sdk.dart';";
}

String _generateMetadataSetter() {
  return [
    '    if (!Localizely.hasMetadata()) {',
    '      Localizely.setMetadata(_metadata);',
    '    }',
  ].join('\n');
}

String _generateMetadata(List<Label> labels) {
  return [
    '  static final Map<String, List<String>> _metadata = {',
    labels.map((label) => label.generateMetadata()).join(',\n'),
    '  };',
  ].join('\n');
}
