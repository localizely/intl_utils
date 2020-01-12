import 'package:intl_utils/src/label.dart';

String generateL10nDartFileContent(String className, List<Label> labels, List<String> locales) {
  return """
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class $className {
  $className(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<$className> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return $className(localeName);
    });
  } 

  static $className of(BuildContext context) {
    return Localizations.of<$className>(context, $className);
  }

  final String localeName;

${labels.map((label) => label.generateDartGetter()).join("\n\n")}
}

class AppLocalizationDelegate extends LocalizationsDelegate<$className> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      ${locales.map((locale) => locale.contains('_') ? 'Locale(\'${locale.split('_')[0]}\', \'${locale.split('_')[1]}\')' : 'Locale(\'${locale.split('_')[0]}\', \'\')').join(', ')}
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<$className> load(Locale locale) => $className.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
"""
      .trim();
}
