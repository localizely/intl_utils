import 'package:test/test.dart';

import 'package:intl_utils/src/parser.dart';
import 'package:intl_utils/src/message_format.dart';

void main() {
  group('Literal messages', () {
    test('Test literal message with empty string', () {
      var response = Parser().parse('');

      expect(response.length, 1);
      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, '');
    });

    test('Test literal message with plain text', () {
      var response = Parser().parse('This is some content.');

      expect(response.length, 1);
      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, 'This is some content.');
    });

    test('Test literal message with special characters', () {
      var response = Parser().parse('Special characters: ,./?\\[]!@#\$%^&*()_+-=');

      expect(response.length, 1);
      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, 'Special characters: ,./?\\[]!@#\$%^&*()_+-=');
    });
  });

  group('Argument messages', () {
    test('Test argument message with placeholder only', () {
      var response = Parser().parse('{firstName}');

      expect(response.length, 1);
      expect(response[0].runtimeType, ArgumentElement);
      expect(response[0].type, ElementType.argument);
      expect(response[0].value, 'firstName');
    });

    test('Test argument message with placeholder and plain text', () {
      var response = Parser().parse('Hi my name is {firstName}!');

      expect(response.length, 3);

      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, 'Hi my name is ');

      expect(response[1].runtimeType, ArgumentElement);
      expect(response[1].type, ElementType.argument);
      expect(response[1].value, 'firstName');

      expect(response[2].runtimeType, LiteralElement);
      expect(response[2].type, ElementType.literal);
      expect(response[2].value, '!');
    });

    test('Test argument message with placeholder and plain text when there are no space around placeholder', () {
      var response = Parser().parse('Link: https://example.com?user={username}&test=yes');

      expect(response.length, 3);

      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, 'Link: https://example.com?user=');

      expect(response[1].runtimeType, ArgumentElement);
      expect(response[1].type, ElementType.argument);
      expect(response[1].value, 'username');

      expect(response[2].runtimeType, LiteralElement);
      expect(response[2].type, ElementType.literal);
      expect(response[2].value, '&test=yes');
    });

    test('Test argument message with few placeholders and plain text', () {
      var response = Parser().parse('My name is {lastName}, {firstName} {lastName}!');

      expect(response.length, 7);

      expect(response[0].runtimeType, LiteralElement);
      expect(response[0].type, ElementType.literal);
      expect(response[0].value, 'My name is ');

      expect(response[1].runtimeType, ArgumentElement);
      expect(response[1].type, ElementType.argument);
      expect(response[1].value, 'lastName');

      expect(response[2].runtimeType, LiteralElement);
      expect(response[2].type, ElementType.literal);
      expect(response[2].value, ', ');

      expect(response[3].runtimeType, ArgumentElement);
      expect(response[3].type, ElementType.argument);
      expect(response[3].value, 'firstName');

      expect(response[4].runtimeType, LiteralElement);
      expect(response[4].type, ElementType.literal);
      expect(response[4].value, ' ');

      expect(response[5].runtimeType, ArgumentElement);
      expect(response[5].type, ElementType.argument);
      expect(response[5].value, 'lastName');

      expect(response[6].runtimeType, LiteralElement);
      expect(response[6].type, ElementType.literal);
      expect(response[6].value, '!');
    });
  });

  group('Plural messages', () {
    test('Test plural message with all plural forms when plural forms have plain text', () {
      var response = Parser().parse(
          '{count, plural, zero {zero message} one {one message} two {two message} few {few message} many {many message} other {other message}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, 'zero');
      expect((response[0] as PluralElement).options[0].value.length, 1);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[0].value, 'zero message');

      expect((response[0] as PluralElement).options[1].name, 'one');
      expect((response[0] as PluralElement).options[1].value.length, 1);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[0].value, 'one message');

      expect((response[0] as PluralElement).options[2].name, 'two');
      expect((response[0] as PluralElement).options[2].value.length, 1);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[0].value, 'two message');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 1);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[0].value, 'few message');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 1);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[0].value, 'many message');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 1);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[0].value, 'other message');
    });

    test('Test plural message with all plural forms when plural forms are empty', () {
      var response = Parser().parse('{count, plural, zero {} one {} two {} few {} many {} other {}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, 'zero');
      expect((response[0] as PluralElement).options[0].value.length, 1);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[0].value, '');

      expect((response[0] as PluralElement).options[1].name, 'one');
      expect((response[0] as PluralElement).options[1].value.length, 1);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[0].value, '');

      expect((response[0] as PluralElement).options[2].name, 'two');
      expect((response[0] as PluralElement).options[2].value.length, 1);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[0].value, '');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 1);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[0].value, '');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 1);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[0].value, '');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 1);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[0].value, '');
    });

    test('Test plural message with all plural forms when there are no whitespace around plural forms', () {
      var response = Parser().parse(
          '{count,plural,zero{zero message}one{one message}two{two message}few{few message}many{many message}other{other message}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, 'zero');
      expect((response[0] as PluralElement).options[0].value.length, 1);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[0].value, 'zero message');

      expect((response[0] as PluralElement).options[1].name, 'one');
      expect((response[0] as PluralElement).options[1].value.length, 1);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[0].value, 'one message');

      expect((response[0] as PluralElement).options[2].name, 'two');
      expect((response[0] as PluralElement).options[2].value.length, 1);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[0].value, 'two message');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 1);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[0].value, 'few message');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 1);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[0].value, 'many message');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 1);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[0].value, 'other message');
    });

    test(
        'Test plural message with all plural forms where zero, one and two plural forms are expressed in the "equal-number" way',
        () {
      var response = Parser().parse(
          '{count, plural, =0 {=0 message} =1 {=1 message} =2 {=2 message} few {few message} many {many message} other {other message}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, '=0');
      expect((response[0] as PluralElement).options[0].value.length, 1);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[0].value, '=0 message');

      expect((response[0] as PluralElement).options[1].name, '=1');
      expect((response[0] as PluralElement).options[1].value.length, 1);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[0].value, '=1 message');

      expect((response[0] as PluralElement).options[2].name, '=2');
      expect((response[0] as PluralElement).options[2].value.length, 1);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[0].value, '=2 message');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 1);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[0].value, 'few message');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 1);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[0].value, 'many message');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 1);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[0].value, 'other message');
    });

    test('Test plural message with all plural forms when plural forms have placeholder', () {
      var response = Parser().parse(
          '{count, plural, zero {zero message with {name} placeholder.} one {one message with {name} placeholder.} two {two message with {name} placeholder.} few {few message with {name} placeholder.} many {many message with {name} placeholder.} other {other message with {name} placeholder.}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, 'zero');
      expect((response[0] as PluralElement).options[0].value.length, 3);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[0].value, 'zero message with ');
      expect((response[0] as PluralElement).options[0].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[0].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[0].value[1].value, 'name');
      expect((response[0] as PluralElement).options[0].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[2].value, ' placeholder.');

      expect((response[0] as PluralElement).options[1].name, 'one');
      expect((response[0] as PluralElement).options[1].value.length, 3);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[0].value, 'one message with ');
      expect((response[0] as PluralElement).options[1].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[1].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[1].value[1].value, 'name');
      expect((response[0] as PluralElement).options[1].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[2].value, ' placeholder.');

      expect((response[0] as PluralElement).options[2].name, 'two');
      expect((response[0] as PluralElement).options[2].value.length, 3);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[0].value, 'two message with ');
      expect((response[0] as PluralElement).options[2].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[2].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[2].value[1].value, 'name');
      expect((response[0] as PluralElement).options[2].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[2].value, ' placeholder.');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 3);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[0].value, 'few message with ');
      expect((response[0] as PluralElement).options[3].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[3].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[3].value[1].value, 'name');
      expect((response[0] as PluralElement).options[3].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[2].value, ' placeholder.');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 3);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[0].value, 'many message with ');
      expect((response[0] as PluralElement).options[4].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[4].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[4].value[1].value, 'name');
      expect((response[0] as PluralElement).options[4].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[2].value, ' placeholder.');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 3);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[0].value, 'other message with ');
      expect((response[0] as PluralElement).options[5].value[1].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[5].value[1].type, ElementType.argument);
      expect((response[0] as PluralElement).options[5].value[1].value, 'name');
      expect((response[0] as PluralElement).options[5].value[2].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[2].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[2].value, ' placeholder.');
    });

    test('Test plural message with all plural forms when plural forms have few placeholders', () {
      var response = Parser().parse(
          '{count, plural, =0 {{firstName} {lastName}: zero message} =1 {{firstName} {lastName}: one message} =2 {{firstName} {lastName}: two message} few {{firstName} {lastName}: few message} many {{firstName} {lastName}: many message} other {{firstName} {lastName}: other message}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 6);

      expect((response[0] as PluralElement).options[0].name, '=0');
      expect((response[0] as PluralElement).options[0].value.length, 4);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[0].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[0].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[1].value, ' ');
      expect((response[0] as PluralElement).options[0].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[0].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[0].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[0].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[3].value, ': zero message');

      expect((response[0] as PluralElement).options[1].name, '=1');
      expect((response[0] as PluralElement).options[1].value.length, 4);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[1].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[1].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[1].value, ' ');
      expect((response[0] as PluralElement).options[1].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[1].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[1].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[1].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[3].value, ': one message');

      expect((response[0] as PluralElement).options[2].name, '=2');
      expect((response[0] as PluralElement).options[2].value.length, 4);
      expect((response[0] as PluralElement).options[2].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[2].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[2].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[2].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[1].value, ' ');
      expect((response[0] as PluralElement).options[2].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[2].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[2].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[2].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[2].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[2].value[3].value, ': two message');

      expect((response[0] as PluralElement).options[3].name, 'few');
      expect((response[0] as PluralElement).options[3].value.length, 4);
      expect((response[0] as PluralElement).options[3].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[3].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[3].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[3].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[1].value, ' ');
      expect((response[0] as PluralElement).options[3].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[3].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[3].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[3].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[3].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[3].value[3].value, ': few message');

      expect((response[0] as PluralElement).options[4].name, 'many');
      expect((response[0] as PluralElement).options[4].value.length, 4);
      expect((response[0] as PluralElement).options[4].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[4].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[4].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[4].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[1].value, ' ');
      expect((response[0] as PluralElement).options[4].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[4].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[4].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[4].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[4].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[4].value[3].value, ': many message');

      expect((response[0] as PluralElement).options[5].name, 'other');
      expect((response[0] as PluralElement).options[5].value.length, 4);
      expect((response[0] as PluralElement).options[5].value[0].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[5].value[0].type, ElementType.argument);
      expect((response[0] as PluralElement).options[5].value[0].value, 'firstName');
      expect((response[0] as PluralElement).options[5].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[1].value, ' ');
      expect((response[0] as PluralElement).options[5].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[5].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[5].value[2].value, 'lastName');
      expect((response[0] as PluralElement).options[5].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[5].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[5].value[3].value, ': other message');
    });

    test('Test plural message with one and other plural forms when plural forms have gender message', () {
      var response = Parser().parse(
          '{count, plural, one {{gender, select, female {Girl has} male {Boy has} other {Person has}} one item} other {{gender, select, female {Girl has} male {Boy has} other {Person has}} {count} items}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, PluralElement);
      expect(response[0].type, ElementType.plural);
      expect(response[0].value, 'count');
      expect((response[0] as PluralElement).options.length, 2);

      expect((response[0] as PluralElement).options[0].name, 'one');
      expect((response[0] as PluralElement).options[0].value.length, 2);
      expect((response[0] as PluralElement).options[0].value[0].runtimeType, GenderElement);
      expect((response[0] as PluralElement).options[0].value[0].type, ElementType.gender);
      expect((response[0] as PluralElement).options[0].value[0].value, 'gender');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options.length, 3);
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[0].name, 'female');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[0].value.length, 1);
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[0].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[0].value[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect(
          ((response[0] as PluralElement).options[0].value[0] as GenderElement).options[0].value[0].value, 'Girl has');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[1].name, 'male');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[1].value.length, 1);
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[1].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[0].value[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect(
          ((response[0] as PluralElement).options[0].value[0] as GenderElement).options[1].value[0].value, 'Boy has');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[2].name, 'other');
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[2].value.length, 1);
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[2].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[0].value[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect(((response[0] as PluralElement).options[0].value[0] as GenderElement).options[2].value[0].value,
          'Person has');
      expect((response[0] as PluralElement).options[0].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[0].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[0].value[1].value, ' one item');

      expect((response[0] as PluralElement).options[1].name, 'other');
      expect((response[0] as PluralElement).options[1].value.length, 4);
      expect((response[0] as PluralElement).options[1].value[0].runtimeType, GenderElement);
      expect((response[0] as PluralElement).options[1].value[0].type, ElementType.gender);
      expect((response[0] as PluralElement).options[1].value[0].value, 'gender');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options.length, 3);
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[0].name, 'female');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[0].value.length, 1);
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[0].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[1].value[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect(
          ((response[0] as PluralElement).options[1].value[0] as GenderElement).options[0].value[0].value, 'Girl has');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[1].name, 'male');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[1].value.length, 1);
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[1].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[1].value[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect(
          ((response[0] as PluralElement).options[1].value[0] as GenderElement).options[1].value[0].value, 'Boy has');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[2].name, 'other');
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[2].value.length, 1);
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[2].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as PluralElement).options[1].value[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect(((response[0] as PluralElement).options[1].value[0] as GenderElement).options[2].value[0].value,
          'Person has');
      expect((response[0] as PluralElement).options[1].value[1].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[1].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[1].value, ' ');
      expect((response[0] as PluralElement).options[1].value[2].runtimeType, ArgumentElement);
      expect((response[0] as PluralElement).options[1].value[2].type, ElementType.argument);
      expect((response[0] as PluralElement).options[1].value[2].value, 'count');
      expect((response[0] as PluralElement).options[1].value[3].runtimeType, LiteralElement);
      expect((response[0] as PluralElement).options[1].value[3].type, ElementType.literal);
      expect((response[0] as PluralElement).options[1].value[3].value, ' items');
    });
  });

  group('Gender messages', () {
    test('Test gender message with all gender forms when gender forms have plain text', () {
      var response = Parser().parse('{gender, select, female {Hi woman!} male {Hi man!} other {Hi there!}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 1);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, 'Hi woman!');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 1);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, 'Hi man!');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 1);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, 'Hi there!');
    });

    test('Test gender message with all gender forms when gender forms are empty', () {
      var response = Parser().parse('{gender, select, female {} male {} other {}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 1);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, '');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 1);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, '');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 1);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, '');
    });

    test('Test gender message with all gender forms when there are no whitespace around gender forms', () {
      var response = Parser().parse('{gender,select,female{Hi woman!}male{Hi man!}other{Hi there!}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 1);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, 'Hi woman!');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 1);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, 'Hi man!');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 1);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, 'Hi there!');
    });

    test('Test gender message with all gender forms when gender forms have placeholder', () {
      var response = Parser()
          .parse('{gender, select, female {Miss {firstName}.} male {Mister {firstName}.} other {User {firstName}.}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 3);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, 'Miss ');
      expect((response[0] as GenderElement).options[0].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[0].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[0].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[0].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[2].value, '.');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 3);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, 'Mister ');
      expect((response[0] as GenderElement).options[1].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[1].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[1].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[1].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[2].value, '.');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 3);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, 'User ');
      expect((response[0] as GenderElement).options[2].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[2].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[2].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[2].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[2].value, '.');
    });

    test('Test gender message with all gender forms when gender forms have few placeholders', () {
      var response = Parser().parse(
          '{gender, select, female {Miss {firstName} {lastName} from {address}.} male {Mister {firstName} {lastName} from {address}.} other {User {firstName} {lastName} from {address}.}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 7);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, 'Miss ');
      expect((response[0] as GenderElement).options[0].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[0].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[0].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[0].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[2].value, ' ');
      expect((response[0] as GenderElement).options[0].value[3].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[0].value[3].type, ElementType.argument);
      expect((response[0] as GenderElement).options[0].value[3].value, 'lastName');
      expect((response[0] as GenderElement).options[0].value[4].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[4].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[4].value, ' from ');
      expect((response[0] as GenderElement).options[0].value[5].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[0].value[5].type, ElementType.argument);
      expect((response[0] as GenderElement).options[0].value[5].value, 'address');
      expect((response[0] as GenderElement).options[0].value[6].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[6].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[6].value, '.');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 7);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, 'Mister ');
      expect((response[0] as GenderElement).options[1].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[1].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[1].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[1].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[2].value, ' ');
      expect((response[0] as GenderElement).options[1].value[3].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[1].value[3].type, ElementType.argument);
      expect((response[0] as GenderElement).options[1].value[3].value, 'lastName');
      expect((response[0] as GenderElement).options[1].value[4].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[4].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[4].value, ' from ');
      expect((response[0] as GenderElement).options[1].value[5].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[1].value[5].type, ElementType.argument);
      expect((response[0] as GenderElement).options[1].value[5].value, 'address');
      expect((response[0] as GenderElement).options[1].value[6].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[6].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[6].value, '.');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 7);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, 'User ');
      expect((response[0] as GenderElement).options[2].value[1].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[2].value[1].type, ElementType.argument);
      expect((response[0] as GenderElement).options[2].value[1].value, 'firstName');
      expect((response[0] as GenderElement).options[2].value[2].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[2].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[2].value, ' ');
      expect((response[0] as GenderElement).options[2].value[3].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[2].value[3].type, ElementType.argument);
      expect((response[0] as GenderElement).options[2].value[3].value, 'lastName');
      expect((response[0] as GenderElement).options[2].value[4].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[4].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[4].value, ' from ');
      expect((response[0] as GenderElement).options[2].value[5].runtimeType, ArgumentElement);
      expect((response[0] as GenderElement).options[2].value[5].type, ElementType.argument);
      expect((response[0] as GenderElement).options[2].value[5].value, 'address');
      expect((response[0] as GenderElement).options[2].value[6].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[6].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[6].value, '.');
    });

    test('Test gender message with all gender forms when gender forms have plural message', () {
      var response = Parser().parse(
          '{gender, select, female {She has {count, plural, one {one apple} other {{count} apples}}} male {He has {count, plural, one {one apple} other {{count} apples}}} other {Person has {count, plural, one {one apple} other {{count} apples}}}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, GenderElement);
      expect(response[0].type, ElementType.gender);
      expect(response[0].value, 'gender');
      expect((response[0] as GenderElement).options.length, 3);

      expect((response[0] as GenderElement).options[0].name, 'female');
      expect((response[0] as GenderElement).options[0].value.length, 2);
      expect((response[0] as GenderElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[0].value[0].value, 'She has ');
      expect((response[0] as GenderElement).options[0].value[1].runtimeType, PluralElement);
      expect((response[0] as GenderElement).options[0].value[1].type, ElementType.plural);
      expect((response[0] as GenderElement).options[0].value[1].value, 'count');
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options.length, 2);
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[0].name, 'one');
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[0].value.length, 1);
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[0].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[0].value[1] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[0].value[1] as PluralElement).options[0].value[0].value, 'one apple');
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].name, 'other');
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value.length, 2);
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[0].runtimeType,
          ArgumentElement);
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[0].type,
          ElementType.argument);
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[0].value, 'count');
      expect(((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[1].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[1].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[0].value[1] as PluralElement).options[1].value[1].value, ' apples');

      expect((response[0] as GenderElement).options[1].name, 'male');
      expect((response[0] as GenderElement).options[1].value.length, 2);
      expect((response[0] as GenderElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[1].value[0].value, 'He has ');
      expect((response[0] as GenderElement).options[1].value[1].runtimeType, PluralElement);
      expect((response[0] as GenderElement).options[1].value[1].type, ElementType.plural);
      expect((response[0] as GenderElement).options[1].value[1].value, 'count');
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options.length, 2);
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[0].name, 'one');
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[0].value.length, 1);
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[0].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[1].value[1] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[1].value[1] as PluralElement).options[0].value[0].value, 'one apple');
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].name, 'other');
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value.length, 2);
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[0].runtimeType,
          ArgumentElement);
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[0].type,
          ElementType.argument);
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[0].value, 'count');
      expect(((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[1].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[1].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[1].value[1] as PluralElement).options[1].value[1].value, ' apples');

      expect((response[0] as GenderElement).options[2].name, 'other');
      expect((response[0] as GenderElement).options[2].value.length, 2);
      expect((response[0] as GenderElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as GenderElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as GenderElement).options[2].value[0].value, 'Person has ');
      expect((response[0] as GenderElement).options[2].value[1].runtimeType, PluralElement);
      expect((response[0] as GenderElement).options[2].value[1].type, ElementType.plural);
      expect((response[0] as GenderElement).options[2].value[1].value, 'count');
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options.length, 2);
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[0].name, 'one');
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[0].value.length, 1);
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[0].value[0].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[2].value[1] as PluralElement).options[0].value[0].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[2].value[1] as PluralElement).options[0].value[0].value, 'one apple');
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].name, 'other');
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value.length, 2);
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[0].runtimeType,
          ArgumentElement);
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[0].type,
          ElementType.argument);
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[0].value, 'count');
      expect(((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[1].runtimeType,
          LiteralElement);
      expect(
          ((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[1].type, ElementType.literal);
      expect(
          ((response[0] as GenderElement).options[2].value[1] as PluralElement).options[1].value[1].value, ' apples');
    });
  });

  group('Select messages', () {
    test('Test select message when select forms have plain text', () {
      var response = Parser()
          .parse('{choice, select, foo {This is foo option} bar {This is bar option} baz {This is baz option}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, SelectElement);
      expect(response[0].type, ElementType.select);
      expect(response[0].value, 'choice');
      expect((response[0] as SelectElement).options.length, 3);

      expect((response[0] as SelectElement).options[0].name, 'foo');
      expect((response[0] as SelectElement).options[0].value.length, 1);
      expect((response[0] as SelectElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[0].value, 'This is foo option');

      expect((response[0] as SelectElement).options[1].name, 'bar');
      expect((response[0] as SelectElement).options[1].value.length, 1);
      expect((response[0] as SelectElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[0].value, 'This is bar option');

      expect((response[0] as SelectElement).options[2].name, 'baz');
      expect((response[0] as SelectElement).options[2].value.length, 1);
      expect((response[0] as SelectElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[0].value, 'This is baz option');
    });

    test('Test select message when select forms are empty', () {
      var response = Parser()
          .parse('{choice, select, foo {} bar {} baz {}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, SelectElement);
      expect(response[0].type, ElementType.select);
      expect(response[0].value, 'choice');
      expect((response[0] as SelectElement).options.length, 3);

      expect((response[0] as SelectElement).options[0].name, 'foo');
      expect((response[0] as SelectElement).options[0].value.length, 1);
      expect((response[0] as SelectElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[0].value, '');

      expect((response[0] as SelectElement).options[1].name, 'bar');
      expect((response[0] as SelectElement).options[1].value.length, 1);
      expect((response[0] as SelectElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[0].value, '');

      expect((response[0] as SelectElement).options[2].name, 'baz');
      expect((response[0] as SelectElement).options[2].value.length, 1);
      expect((response[0] as SelectElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[0].value, '');
    });

    test('Test select message when there are no whitespace around select forms', () {
      var response =
          Parser().parse('{choice,select,foo{This is foo option}bar{This is bar option}baz{This is baz option}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, SelectElement);
      expect(response[0].type, ElementType.select);
      expect(response[0].value, 'choice');
      expect((response[0] as SelectElement).options.length, 3);

      expect((response[0] as SelectElement).options[0].name, 'foo');
      expect((response[0] as SelectElement).options[0].value.length, 1);
      expect((response[0] as SelectElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[0].value, 'This is foo option');

      expect((response[0] as SelectElement).options[1].name, 'bar');
      expect((response[0] as SelectElement).options[1].value.length, 1);
      expect((response[0] as SelectElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[0].value, 'This is bar option');

      expect((response[0] as SelectElement).options[2].name, 'baz');
      expect((response[0] as SelectElement).options[2].value.length, 1);
      expect((response[0] as SelectElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[0].value, 'This is baz option');
    });

    test('Test select message when select forms have placeholder', () {
      var response = Parser().parse(
          '{choice, select, foo {This is foo option with {name} placeholder} bar {This is bar option with {name} placeholder} baz {This is baz option with {name} placeholder}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, SelectElement);
      expect(response[0].type, ElementType.select);
      expect(response[0].value, 'choice');
      expect((response[0] as SelectElement).options.length, 3);

      expect((response[0] as SelectElement).options[0].name, 'foo');
      expect((response[0] as SelectElement).options[0].value.length, 3);
      expect((response[0] as SelectElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[0].value, 'This is foo option with ');
      expect((response[0] as SelectElement).options[0].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[0].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[0].value[1].value, 'name');
      expect((response[0] as SelectElement).options[0].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[2].value, ' placeholder');

      expect((response[0] as SelectElement).options[1].name, 'bar');
      expect((response[0] as SelectElement).options[1].value.length, 3);
      expect((response[0] as SelectElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[0].value, 'This is bar option with ');
      expect((response[0] as SelectElement).options[1].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[1].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[1].value[1].value, 'name');
      expect((response[0] as SelectElement).options[1].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[2].value, ' placeholder');

      expect((response[0] as SelectElement).options[2].name, 'baz');
      expect((response[0] as SelectElement).options[2].value.length, 3);
      expect((response[0] as SelectElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[0].value, 'This is baz option with ');
      expect((response[0] as SelectElement).options[2].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[2].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[2].value[1].value, 'name');
      expect((response[0] as SelectElement).options[2].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[2].value, ' placeholder');
    });

    test('Test select message when select forms have few placeholders', () {
      var response = Parser().parse(
          '{choice, select, foo {Foo: {firstName} {lastName}} bar {Bar: {firstName} {lastName}} baz {Baz: {firstName} {lastName}}}');

      expect(response.length, 1);
      expect(response[0].runtimeType, SelectElement);
      expect(response[0].type, ElementType.select);
      expect(response[0].value, 'choice');
      expect((response[0] as SelectElement).options.length, 3);

      expect((response[0] as SelectElement).options[0].name, 'foo');
      expect((response[0] as SelectElement).options[0].value.length, 4);
      expect((response[0] as SelectElement).options[0].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[0].value, 'Foo: ');
      expect((response[0] as SelectElement).options[0].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[0].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[0].value[1].value, 'firstName');
      expect((response[0] as SelectElement).options[0].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[0].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[0].value[2].value, ' ');
      expect((response[0] as SelectElement).options[0].value[3].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[0].value[3].type, ElementType.argument);
      expect((response[0] as SelectElement).options[0].value[3].value, 'lastName');

      expect((response[0] as SelectElement).options[1].name, 'bar');
      expect((response[0] as SelectElement).options[1].value.length, 4);
      expect((response[0] as SelectElement).options[1].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[0].value, 'Bar: ');
      expect((response[0] as SelectElement).options[1].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[1].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[1].value[1].value, 'firstName');
      expect((response[0] as SelectElement).options[1].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[1].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[1].value[2].value, ' ');
      expect((response[0] as SelectElement).options[1].value[3].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[1].value[3].type, ElementType.argument);
      expect((response[0] as SelectElement).options[1].value[3].value, 'lastName');

      expect((response[0] as SelectElement).options[2].name, 'baz');
      expect((response[0] as SelectElement).options[2].value.length, 4);
      expect((response[0] as SelectElement).options[2].value[0].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[0].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[0].value, 'Baz: ');
      expect((response[0] as SelectElement).options[2].value[1].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[2].value[1].type, ElementType.argument);
      expect((response[0] as SelectElement).options[2].value[1].value, 'firstName');
      expect((response[0] as SelectElement).options[2].value[2].runtimeType, LiteralElement);
      expect((response[0] as SelectElement).options[2].value[2].type, ElementType.literal);
      expect((response[0] as SelectElement).options[2].value[2].value, ' ');
      expect((response[0] as SelectElement).options[2].value[3].runtimeType, ArgumentElement);
      expect((response[0] as SelectElement).options[2].value[3].type, ElementType.argument);
      expect((response[0] as SelectElement).options[2].value[3].value, 'lastName');
    });
  });
}
