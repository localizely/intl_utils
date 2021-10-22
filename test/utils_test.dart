import 'package:intl_utils/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Path validation', () {
    test('Test path validation with blank string',
        () => expect(isValidPath('  '), isFalse));

    test('Test path validation with forbidden path character *',
        () => expect(isValidPath('te*/lib'), isFalse));

    test('Test path validation with forbidden path character "',
        () => expect(isValidPath('te"/lib'), isFalse));

    test('Test path validation with forbidden path character ?',
        () => expect(isValidPath('te?/lib'), isFalse));

    test('Test path validation with empty string',
        () => expect(isValidPath(''), isTrue));

    test('Test path validation with Windows path',
        () => expect(isValidPath(r'lib\l10n'), isTrue));

    test('Test path validation with UNIX path',
        () => expect(isValidPath('lib/l10n'), isTrue));

    test('Test path validation with escaped path separators',
        () => expect(isValidPath('lib\\l10n'), isTrue));

    test('Test path validation with dual path separators',
        () => expect(isValidPath('lib//l10n'), isTrue));

    test('Test path validation with Windows absolute path',
        () => expect(isValidPath('C:\\dart\\l10n'), isTrue));
  });

  group('Download empty as param validation', () {
    test('Test download empty as param with empty string',
        () => expect(isValidDownloadEmptyAsParam(''), isFalse));

    test('Test download empty as param with blank string',
        () => expect(isValidDownloadEmptyAsParam('  '), isFalse));

    test('Test download empty as param with unsupported value',
        () => expect(isValidDownloadEmptyAsParam('unsupported'), isFalse));

    test('Test download empty as param with invalid empty value',
        () => expect(isValidDownloadEmptyAsParam('emty'), isFalse));

    test('Test download empty as param with empty value',
        () => expect(isValidDownloadEmptyAsParam('empty'), isTrue));

    test('Test download empty as param with invalid main value',
        () => expect(isValidDownloadEmptyAsParam('mmain'), isFalse));

    test('Test download empty as param with main value',
        () => expect(isValidDownloadEmptyAsParam('main'), isTrue));

    test('Test download empty as param with invalid skip value',
        () => expect(isValidDownloadEmptyAsParam('skipp'), isFalse));

    test('Test download empty as param with skip value',
        () => expect(isValidDownloadEmptyAsParam('skip'), isTrue));
  });

  group('Locale validation', () {
    test('Test locale validation with empty string',
        () => expect(isValidLocale(''), isFalse));

    test('Test locale validation with blank string',
        () => expect(isValidLocale('  '), isFalse));

    test('Test locale validation with plain text',
        () => expect(isValidLocale('some text'), isFalse));

    test(
        'Test locale validation with invalid locale where language code is uppercased',
        () => expect(isValidLocale('FR'), isFalse));

    test(
        'Test locale validation with invalid locale where language code is mixcased',
        () => expect(isValidLocale('eS'), isFalse));

    test(
        'Test locale validation with invalid locale where language code contains special character',
        () => expect(isValidLocale('d#'), isFalse));

    test(
        'Test locale validation with invalid locale where language code contains white space',
        () => expect(isValidLocale('d '), isFalse));

    test(
        'Test locale validation with valid locale consisted only of language code',
        () => expect(isValidLocale('en'), isTrue));

    test(
        'Test locale validation with invalid locale where language code is consisted of three letters',
        () => expect(isValidLocale('bih'), isFalse));

    test(
        'Test locale validation with invalid locale where language code is consisted of four letters',
        () => expect(isValidLocale('engb'), isFalse));

    test(
        'Test locale validation with invalid locale where language and country codes are separated with dash',
        () => expect(isValidLocale('en-gb'), isFalse));

    test(
        'Test locale validation with invalid locale where country code is lowercased',
        () => expect(isValidLocale('en_gb'), isFalse));

    test(
        'Test locale validation with valid locale consisted of language and country codes',
        () => expect(isValidLocale('en_GB'), isTrue));

    test(
        'Test locale validation with invalid locale where country code is consisted of three letters',
        () => expect(isValidLocale('en_GBR'), isFalse));

    test(
        'Test locale validation with invalid locale where country code is consisted of four letters',
        () => expect(isValidLocale('en_UKGB'), isFalse));

    test(
        'Test locale validation with invalid locale where script code is lowercased',
        () => expect(isValidLocale('zh_hans'), isFalse));

    test(
        'Test locale validation with valid locale consisted of language and script codes',
        () => expect(isValidLocale('zh_Hans'), isTrue));

    test(
        'Test locale validation with invalid locale where script code is lowercased and country code is provided',
        () => expect(isValidLocale('zh_hans_CN'), isFalse));

    test(
        'Test locale validation with valid locale consisted of language, script and country codes',
        () => expect(isValidLocale('zh_Hans_CN'), isTrue));
  });
}
