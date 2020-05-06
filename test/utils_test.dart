import 'package:test/test.dart';

import 'package:intl_utils/src/utils/utils.dart';

void main() {
  group('locale validation', () {
    test('Test locale validation with number value', () {
      var locale = 11;
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with boolean value', () {
      var locale = true;
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with empty string', () {
      var locale = '';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with blank string', () {
      var locale = '  ';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with plain text', () {
      var locale = 'some text';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language code is uppercased', () {
      var locale = 'FR';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language code is mixcased', () {
      var locale = 'eS';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language code contains special character', () {
      var locale = 'd#';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language code contains white space', () {
      var locale = 'd ';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid locale consisted of language code', () {
      var locale = 'en';
      expect(validateLocale(locale), isTrue);
    });

    test('Test locale validation with invalid locale where language code consists of three letters', () {
      var locale = 'bih';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language code consists of four letters', () {
      var locale = 'engb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where language and country codes are separated with dash', () {
      var locale = 'en-gb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where country code is lowercased', () {
      var locale = 'en_gb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid locale consisted of language and country codes', () {
      var locale = 'en_GB';
      expect(validateLocale(locale), isTrue);
    });

    test('Test locale validation with invalid locale where country code consists of three letters', () {
      var locale = 'en_GBR';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where country code consists of four letters', () {
      var locale = 'en_UKGB';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid locale where script code is lowercased', () {
      var locale = 'zh_hans';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid locale consisted of language and script codes', () {
      var locale = 'zh_Hans';
      expect(validateLocale(locale), isTrue);
    });

    test('Test locale validation with invalid locale where script code is lowercased and country code is provided', () {
      var locale = 'zh_hans_CN';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid locale consisted of language, script and country codes', () {
      var locale = 'zh_Hans_CN';
      expect(validateLocale(locale), isTrue);
    });
  });
}
