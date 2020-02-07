import 'package:test/test.dart';
import 'package:intl_utils/src/utils.dart';

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

    test('Test locale validation with empty string value', () {
      var locale = '';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with white spaces string value', () {
      var locale = '  ';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with plain text string value', () {
      var locale = 'some text';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with uppercased two letters language code string value', () {
      var locale = 'FR';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with mixcased two letters language code string value', () {
      var locale = 'eS';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with special character in two letters language code string value', () {
      var locale = 'd#';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with invalid two letters language code string value', () {
      var locale = 'd ';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid lowercased two letters language code string value', () {
      var locale = 'en';
      expect(validateLocale(locale), isTrue);
    });

    test('Test locale validation with lowercased three letters language code string value', () {
      var locale = 'bih';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with lowercased four letters language code string value', () {
      var locale = 'engb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with lowercased four letters language code and dash string value', () {
      var locale = 'en-gb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with lowercased four letters language code and underscore string value', () {
      var locale = 'en_gb';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with valid four letters language code string value', () {
      var locale = 'en_GB';
      expect(validateLocale(locale), isTrue);
    });

    test('Test locale validation with five letters language code string value', () {
      var locale = 'en_GBR';
      expect(validateLocale(locale), isFalse);
    });

    test('Test locale validation with six letters language code string value', () {
      var locale = 'en_UKGB';
      expect(validateLocale(locale), isFalse);
    });
  });
}
