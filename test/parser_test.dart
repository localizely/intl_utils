import 'package:intl_utils/src/parser/icu_parser.dart';
import 'package:intl_utils/src/parser/message_format.dart';
import 'package:test/test.dart';

void main() {
  group('Literal messages', () {
    test('Test literal message with empty string', () {
      var response = IcuParser().parse('');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals(''));
    });

    test('Test literal message with plain text', () {
      var response = IcuParser().parse('This is some content.');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('This is some content.'));
    });

    test('Test literal message with special characters', () {
      var response =
          IcuParser().parse('Special characters: ,./?\\[]!@#\$%^&*()_+-=');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Special characters: ,./?\\[]!@#\$%^&*()_+-='));
    });

    test('Test literal message with a tag', () {
      var response = IcuParser().parse('Literal message with a <b>tag</b>.');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Literal message with a <b>tag</b>.'));
    });

    test('Test literal message wrapped with tag', () {
      var response =
          IcuParser().parse('<p>Literal message with a <b>tag</b>.</p>');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('<p>Literal message with a <b>tag</b>.</p>'));
    });

    test('Test literal message with different tags', () {
      var response = IcuParser()
          .parse('<p>Literal <i>message</i> with a <br/> <b>tag</b>.</p><br>');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('<p>Literal <i>message</i> with a <br/> <b>tag</b>.</p><br>'));
    });

    test('Test literal message with a less-than sign', () {
      var response = IcuParser().parse('Literal message with a < sign.');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Literal message with a < sign.'));
    });

    test('Test literal message with a greater-than sign', () {
      var response = IcuParser().parse('Literal message with a > sign.');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Literal message with a > sign.'));
    });

    test('Test literal message with a simple json string', () {
      var response =
          IcuParser().parse('{ "firstName": "John", "lastName": "Doe" }');

      expect(response, isNotNull);
      expect(response?.length, equals(2));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('{'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value,
          equals(' "firstName": "John", "lastName": "Doe" }'));
    });

    test('Test literal message with a nested json string', () {
      var response = IcuParser().parse(
          '{ "firstName": "John", "lastName": "Doe", "address": { "street": "Some street 123", "city": "Some city" } }');

      expect(response, isNotNull);
      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('{'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value,
          equals(' "firstName": "John", "lastName": "Doe", "address": '));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('{'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value,
          equals(' "street": "Some street 123", "city": "Some city" } }'));
    });

    test('Test literal message with a complex json string', () {
      var response = IcuParser().parse(
          '{ "firstName": "John", "lastName": "Doe", "address": { "street": "Some street 123", "city": "Some city" }, "skills": [ { "name": "programming" }, { "name": "design" } ] }');

      expect(response, isNotNull);
      expect(response?.length, equals(8));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('{'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value,
          equals(' "firstName": "John", "lastName": "Doe", "address": '));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('{'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(
          response?.elementAt(3).value,
          equals(
              ' "street": "Some street 123", "city": "Some city" }, "skills": [ '));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('{'));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(
          response?.elementAt(5).value, equals(' "name": "programming" }, '));

      expect(response?.elementAt(6).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(6).type, equals(ElementType.literal));
      expect(response?.elementAt(6).value, equals('{'));

      expect(response?.elementAt(7).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(7).type, equals(ElementType.literal));
      expect(response?.elementAt(7).value, equals(' "name": "design" } ] }'));
    });
  });

  group('Argument messages', () {
    test('Test argument message with placeholder only', () {
      var response = IcuParser().parse('{firstName}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(0).type, equals(ElementType.argument));
      expect(response?.elementAt(0).value, equals('firstName'));
    });

    test('Test argument message with placeholder and plain text', () {
      var response = IcuParser().parse('Hi my name is {firstName}!');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Hi my name is '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('firstName'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('!'));
    });

    test(
        'Test argument message with placeholder and plain text when there are no space around placeholder',
        () {
      var response = IcuParser()
          .parse('Link: https://example.com?user={username}&test=yes');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('Link: https://example.com?user='));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('username'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('&test=yes'));
    });

    test('Test argument message with few placeholders and plain text', () {
      var response =
          IcuParser().parse('My name is {lastName}, {firstName} {lastName}!');

      expect(response, isNotNull);
      expect(response?.length, equals(7));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('My name is '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('lastName'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(', '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('firstName'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' '));

      expect(response?.elementAt(5).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(5).type, equals(ElementType.argument));
      expect(response?.elementAt(5).value, equals('lastName'));

      expect(response?.elementAt(6).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(6).type, equals(ElementType.literal));
      expect(response?.elementAt(6).value, equals('!'));
    });

    test(
        'Test argument message with placeholder and plain text that contains tags',
        () {
      var response = IcuParser().parse(
          'Argument message with <em>{placeholder}</em> and <b>tag</b>!');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(
          response?.elementAt(0).value, equals('Argument message with <em>'));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('placeholder'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('</em> and <b>tag</b>!'));
    });

    test(
        'Test argument message with placeholder and plain text wrapped with a tag',
        () {
      var response = IcuParser().parse(
          '<p>Argument message with <em>{placeholder}</em> and <b>tag</b>!</p>');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('<p>Argument message with <em>'));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('placeholder'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('</em> and <b>tag</b>!</p>'));
    });

    test(
        'Test argument message with placeholder and plain text that contains different tags',
        () {
      var response = IcuParser().parse(
          '<p>Argument <i>message</i> with <br/> <em>{placeholder}</em> and <b>tag</b>!</p><br>');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value,
          equals('<p>Argument <i>message</i> with <br/> <em>'));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('placeholder'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value,
          equals('</em> and <b>tag</b>!</p><br>'));
    });

    test(
        'Test argument message with placeholder and plain text that contains less-than sign',
        () {
      var response =
          IcuParser().parse('Argument message with {placeholder} and < sign.');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Argument message with '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('placeholder'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' and < sign.'));
    });

    test(
        'Test argument message with placeholder and plain text that contains greater-than sign',
        () {
      var response =
          IcuParser().parse('Argument message with {placeholder} and > sign.');

      expect(response, isNotNull);
      expect(response?.length, equals(3));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Argument message with '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('placeholder'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' and > sign.'));
    });

    test('Test argument message when content contains a simple json string',
        () {
      var response = IcuParser().parse(
          'Argument message: {name} - { "firstName": "John", "lastName": "Doe" }');

      expect(response, isNotNull);
      expect(response?.length, equals(5));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Argument message: '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' - '));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals('{'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value,
          equals(' "firstName": "John", "lastName": "Doe" }'));
    });

    test('Test argument message when content contains a nested json string',
        () {
      var response = IcuParser().parse(
          'Argument message: {name} - { "firstName": "John", "lastName": "Doe", "address": { "street": "Some street 123", "city": "Some city" } }');

      expect(response, isNotNull);
      expect(response?.length, equals(7));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Argument message: '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' - '));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals('{'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value,
          equals(' "firstName": "John", "lastName": "Doe", "address": '));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(response?.elementAt(5).value, equals('{'));

      expect(response?.elementAt(6).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(6).type, equals(ElementType.literal));
      expect(response?.elementAt(6).value,
          equals(' "street": "Some street 123", "city": "Some city" } }'));
    });

    test('Test argument message when content contains a complex json string',
        () {
      var response = IcuParser().parse(
          'Argument message: {name} - { "firstName": "John", "lastName": "Doe", "address": { "street": "Some street 123", "city": "Some city" }, "skills": [ { "name": "programming" }, { "name": "design" } ] }');

      expect(response, isNotNull);
      expect(response?.length, equals(11));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Argument message: '));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' - '));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals('{'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value,
          equals(' "firstName": "John", "lastName": "Doe", "address": '));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(response?.elementAt(5).value, equals('{'));

      expect(response?.elementAt(6).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(6).type, equals(ElementType.literal));
      expect(
          response?.elementAt(6).value,
          equals(
              ' "street": "Some street 123", "city": "Some city" }, "skills": [ '));

      expect(response?.elementAt(7).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(7).type, equals(ElementType.literal));
      expect(response?.elementAt(7).value, equals('{'));

      expect(response?.elementAt(8).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(8).type, equals(ElementType.literal));
      expect(
          response?.elementAt(8).value, equals(' "name": "programming" }, '));

      expect(response?.elementAt(9).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(9).type, equals(ElementType.literal));
      expect(response?.elementAt(9).value, equals('{'));

      expect(response?.elementAt(10).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(10).type, equals(ElementType.literal));
      expect(response?.elementAt(10).value, equals(' "name": "design" } ] }'));
    });

    test(
        'Test argument message when content contains a json string with placeholders',
        () {
      var response = IcuParser().parse(
          '{ "name": "{name}", "address": { "street": "{street}", "city": "{city}" } }');

      expect(response, isNotNull);
      expect(response?.length, equals(10));

      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('{'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' "name": "'));

      expect(response?.elementAt(2).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(2).type, equals(ElementType.argument));
      expect(response?.elementAt(2).value, equals('name'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals('", "address": '));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('{'));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(response?.elementAt(5).value, equals(' "street": "'));

      expect(response?.elementAt(6).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(6).type, equals(ElementType.argument));
      expect(response?.elementAt(6).value, equals('street'));

      expect(response?.elementAt(7).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(7).type, equals(ElementType.literal));
      expect(response?.elementAt(7).value, equals('", "city": "'));

      expect(response?.elementAt(8).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(8).type, equals(ElementType.argument));
      expect(response?.elementAt(8).value, equals('city'));

      expect(response?.elementAt(9).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(9).type, equals(ElementType.literal));
      expect(response?.elementAt(9).value, equals('" } }'));
    });
  });

  group('Plural messages', () {
    test(
        'Test plural message with all plural forms when plural forms have plain text',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message} one {one message} two {two message} few {few message} many {many message} other {other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms when plural forms are empty',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {} one {} two {} few {} many {} other {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals(''));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals(''));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals(''));
    });

    test(
        'Test plural message with all plural forms when there are no whitespace around plural forms',
        () {
      var response = IcuParser().parse(
          '{count,plural,zero{zero message}one{one message}two{two message}few{few message}many{many message}other{other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms where zero, one and two plural forms are expressed in the "equal-number" way',
        () {
      var response = IcuParser().parse(
          '{count, plural, =0 {=0 message} =1 {=1 message} =2 {=2 message} few {few message} many {many message} other {other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('=0'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('=0 message'));

      expect(options[1].name, equals('=1'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('=1 message'));

      expect(options[2].name, equals('=2'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('=2 message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message'));
    });

    test(
        'Test plural message with all plural forms when plural forms have placeholder',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message with {name} placeholder.} one {one message with {name} placeholder.} two {two message with {name} placeholder.} few {few message with {name} placeholder.} many {many message with {name} placeholder.} other {other message with {name} placeholder.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message with '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' placeholder.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message with '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' placeholder.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message with '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' placeholder.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(3));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message with '));
      expect(options[3].value[1].runtimeType, equals(ArgumentElement));
      expect(options[3].value[1].type, equals(ElementType.argument));
      expect(options[3].value[1].value, equals('name'));
      expect(options[3].value[2].runtimeType, equals(LiteralElement));
      expect(options[3].value[2].type, equals(ElementType.literal));
      expect(options[3].value[2].value, equals(' placeholder.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(3));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message with '));
      expect(options[4].value[1].runtimeType, equals(ArgumentElement));
      expect(options[4].value[1].type, equals(ElementType.argument));
      expect(options[4].value[1].value, equals('name'));
      expect(options[4].value[2].runtimeType, equals(LiteralElement));
      expect(options[4].value[2].type, equals(ElementType.literal));
      expect(options[4].value[2].value, equals(' placeholder.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(3));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message with '));
      expect(options[5].value[1].runtimeType, equals(ArgumentElement));
      expect(options[5].value[1].type, equals(ElementType.argument));
      expect(options[5].value[1].value, equals('name'));
      expect(options[5].value[2].runtimeType, equals(LiteralElement));
      expect(options[5].value[2].type, equals(ElementType.literal));
      expect(options[5].value[2].value, equals(' placeholder.'));
    });

    test(
        'Test plural message with all plural forms when plural forms have few placeholders',
        () {
      var response = IcuParser().parse(
          '{count, plural, =0 {{firstName} {lastName}: zero message} =1 {{firstName} {lastName}: one message} =2 {{firstName} {lastName}: two message} few {{firstName} {lastName}: few message} many {{firstName} {lastName}: many message} other {{firstName} {lastName}: other message}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('=0'));
      expect(options[0].value.length, equals(4));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('firstName'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' '));
      expect(options[0].value[2].runtimeType, equals(ArgumentElement));
      expect(options[0].value[2].type, equals(ElementType.argument));
      expect(options[0].value[2].value, equals('lastName'));
      expect(options[0].value[3].runtimeType, equals(LiteralElement));
      expect(options[0].value[3].type, equals(ElementType.literal));
      expect(options[0].value[3].value, equals(': zero message'));

      expect(options[1].name, equals('=1'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('firstName'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' '));
      expect(options[1].value[2].runtimeType, equals(ArgumentElement));
      expect(options[1].value[2].type, equals(ElementType.argument));
      expect(options[1].value[2].value, equals('lastName'));
      expect(options[1].value[3].runtimeType, equals(LiteralElement));
      expect(options[1].value[3].type, equals(ElementType.literal));
      expect(options[1].value[3].value, equals(': one message'));

      expect(options[2].name, equals('=2'));
      expect(options[2].value.length, equals(4));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('firstName'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' '));
      expect(options[2].value[2].runtimeType, equals(ArgumentElement));
      expect(options[2].value[2].type, equals(ElementType.argument));
      expect(options[2].value[2].value, equals('lastName'));
      expect(options[2].value[3].runtimeType, equals(LiteralElement));
      expect(options[2].value[3].type, equals(ElementType.literal));
      expect(options[2].value[3].value, equals(': two message'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(4));
      expect(options[3].value[0].runtimeType, equals(ArgumentElement));
      expect(options[3].value[0].type, equals(ElementType.argument));
      expect(options[3].value[0].value, equals('firstName'));
      expect(options[3].value[1].runtimeType, equals(LiteralElement));
      expect(options[3].value[1].type, equals(ElementType.literal));
      expect(options[3].value[1].value, equals(' '));
      expect(options[3].value[2].runtimeType, equals(ArgumentElement));
      expect(options[3].value[2].type, equals(ElementType.argument));
      expect(options[3].value[2].value, equals('lastName'));
      expect(options[3].value[3].runtimeType, equals(LiteralElement));
      expect(options[3].value[3].type, equals(ElementType.literal));
      expect(options[3].value[3].value, equals(': few message'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(4));
      expect(options[4].value[0].runtimeType, equals(ArgumentElement));
      expect(options[4].value[0].type, equals(ElementType.argument));
      expect(options[4].value[0].value, equals('firstName'));
      expect(options[4].value[1].runtimeType, equals(LiteralElement));
      expect(options[4].value[1].type, equals(ElementType.literal));
      expect(options[4].value[1].value, equals(' '));
      expect(options[4].value[2].runtimeType, equals(ArgumentElement));
      expect(options[4].value[2].type, equals(ElementType.argument));
      expect(options[4].value[2].value, equals('lastName'));
      expect(options[4].value[3].runtimeType, equals(LiteralElement));
      expect(options[4].value[3].type, equals(ElementType.literal));
      expect(options[4].value[3].value, equals(': many message'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(4));
      expect(options[5].value[0].runtimeType, equals(ArgumentElement));
      expect(options[5].value[0].type, equals(ElementType.argument));
      expect(options[5].value[0].value, equals('firstName'));
      expect(options[5].value[1].runtimeType, equals(LiteralElement));
      expect(options[5].value[1].type, equals(ElementType.literal));
      expect(options[5].value[1].value, equals(' '));
      expect(options[5].value[2].runtimeType, equals(ArgumentElement));
      expect(options[5].value[2].type, equals(ElementType.argument));
      expect(options[5].value[2].value, equals('lastName'));
      expect(options[5].value[3].runtimeType, equals(LiteralElement));
      expect(options[5].value[3].type, equals(ElementType.literal));
      expect(options[5].value[3].value, equals(': other message'));
    });

    test(
        'Test plural message with one and other plural forms when plural forms have gender message',
        () {
      var response = IcuParser().parse(
          '{count, plural, one {{gender, select, female {Girl has} male {Boy has} other {Person has}} one item} other {{gender, select, female {Girl has} male {Boy has} other {Person has}} {count} items}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(GenderElement));
      expect(options[0].value[0].type, equals(ElementType.gender));
      expect(options[0].value[0].value, equals('gender'));

      var pluOneGenOpt = (options[0].value[0] as GenderElement).options;

      expect(pluOneGenOpt.length, equals(3));
      expect(pluOneGenOpt[0].name, equals('female'));
      expect(pluOneGenOpt[0].value.length, equals(1));
      expect(pluOneGenOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[0].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[0].value[0].value, equals('Girl has'));
      expect(pluOneGenOpt[1].name, equals('male'));
      expect(pluOneGenOpt[1].value.length, equals(1));
      expect(pluOneGenOpt[1].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[1].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[1].value[0].value, equals('Boy has'));
      expect(pluOneGenOpt[2].name, equals('other'));
      expect(pluOneGenOpt[2].value.length, equals(1));
      expect(pluOneGenOpt[2].value[0].runtimeType, equals(LiteralElement));
      expect(pluOneGenOpt[2].value[0].type, equals(ElementType.literal));
      expect(pluOneGenOpt[2].value[0].value, equals('Person has'));

      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' one item'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(GenderElement));
      expect(options[1].value[0].type, equals(ElementType.gender));
      expect(options[1].value[0].value, equals('gender'));

      var pluOtherGenOpt = (options[1].value[0] as GenderElement).options;

      expect(pluOtherGenOpt.length, equals(3));
      expect(pluOtherGenOpt[0].name, equals('female'));
      expect(pluOtherGenOpt[0].value.length, equals(1));
      expect(pluOtherGenOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[0].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[0].value[0].value, equals('Girl has'));
      expect(pluOtherGenOpt[1].name, equals('male'));
      expect(pluOtherGenOpt[1].value.length, equals(1));
      expect(pluOtherGenOpt[1].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[1].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[1].value[0].value, equals('Boy has'));
      expect(pluOtherGenOpt[2].name, equals('other'));
      expect(pluOtherGenOpt[2].value.length, equals(1));
      expect(pluOtherGenOpt[2].value[0].runtimeType, equals(LiteralElement));
      expect(pluOtherGenOpt[2].value[0].type, equals(ElementType.literal));
      expect(pluOtherGenOpt[2].value[0].value, equals('Person has'));

      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' '));
      expect(options[1].value[2].runtimeType, equals(ArgumentElement));
      expect(options[1].value[2].type, equals(ElementType.argument));
      expect(options[1].value[2].value, equals('count'));
      expect(options[1].value[3].runtimeType, equals(LiteralElement));
      expect(options[1].value[3].type, equals(ElementType.literal));
      expect(options[1].value[3].value, equals(' items'));
    });

    // Note: Tags are not supported in plural messages with the current parser implementation. Use compound messages as an alternative.
    test('Test plural message with all plural forms when plural forms have tag',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {<b>zero</b> message.} one {<b>one</b> message.} two {<b>two</b> message.} few {<b>few</b> message.} many {<b>many</b> message.} other {<b>other</b> message.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>zero</b> message.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>one</b> message.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>two</b> message.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('<b>few</b> message.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('<b>many</b> message.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('<b>other</b> message.'));
    }, skip: true);

    // Note: Tags are not supported in plural messages with the current parser implementation. Use compound messages as an alternative.
    test(
        'Test plural message with all plural forms when plural forms have placeholder and tag',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {<b>zero</b> message {placeholder}.} one {<b>one</b> message {placeholder}.} two {<b>two</b> message {placeholder}.} few {<b>few</b> message {placeholder}.} many {<b>many</b> message {placeholder}.} other {<b>other</b> message {placeholder}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>zero</b> message '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('placeholder'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals('.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>one</b> message '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('placeholder'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals('.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>two</b> message '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('placeholder'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals('.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(3));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('<b>few</b> message '));
      expect(options[3].value[1].runtimeType, equals(ArgumentElement));
      expect(options[3].value[1].type, equals(ElementType.argument));
      expect(options[3].value[1].value, equals('placeholder'));
      expect(options[3].value[2].runtimeType, equals(LiteralElement));
      expect(options[3].value[2].type, equals(ElementType.literal));
      expect(options[3].value[2].value, equals('.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(3));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('<b>many</b> message '));
      expect(options[4].value[1].runtimeType, equals(ArgumentElement));
      expect(options[4].value[1].type, equals(ElementType.argument));
      expect(options[4].value[1].value, equals('placeholder'));
      expect(options[4].value[2].runtimeType, equals(LiteralElement));
      expect(options[4].value[2].type, equals(ElementType.literal));
      expect(options[4].value[2].value, equals('.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(3));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('<b>other</b> message '));
      expect(options[5].value[1].runtimeType, equals(ArgumentElement));
      expect(options[5].value[1].type, equals(ElementType.argument));
      expect(options[5].value[1].value, equals('placeholder'));
      expect(options[5].value[2].runtimeType, equals(LiteralElement));
      expect(options[5].value[2].type, equals(ElementType.literal));
      expect(options[5].value[2].value, equals('.'));
    }, skip: true);

    // Note: Less-than sign is not supported in plural messages with the current parser implementation. Use compound messages as an alternative.
    test(
        'Test plural message with all plural forms when plural forms have less-than sign',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message with < sign.} one {one message with < sign.} two {two message with < sign.} few {few message with < sign.} many {many message with < sign.} other {other message with < sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message with < sign.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message with < sign.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message with < sign.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message with < sign.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message with < sign.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message with < sign.'));
    }, skip: true);

    test(
        'Test plural message with all plural forms when plural forms have greater-than sign',
        () {
      var response = IcuParser().parse(
          '{count, plural, zero {zero message with > sign.} one {one message with > sign.} two {two message with > sign.} few {few message with > sign.} many {many message with > sign.} other {other message with > sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count'));

      var options = (response?.elementAt(0) as PluralElement).options;

      expect(options.length, equals(6));

      expect(options[0].name, equals('zero'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('zero message with > sign.'));

      expect(options[1].name, equals('one'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('one message with > sign.'));

      expect(options[2].name, equals('two'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('two message with > sign.'));

      expect(options[3].name, equals('few'));
      expect(options[3].value.length, equals(1));
      expect(options[3].value[0].runtimeType, equals(LiteralElement));
      expect(options[3].value[0].type, equals(ElementType.literal));
      expect(options[3].value[0].value, equals('few message with > sign.'));

      expect(options[4].name, equals('many'));
      expect(options[4].value.length, equals(1));
      expect(options[4].value[0].runtimeType, equals(LiteralElement));
      expect(options[4].value[0].type, equals(ElementType.literal));
      expect(options[4].value[0].value, equals('many message with > sign.'));

      expect(options[5].name, equals('other'));
      expect(options[5].value.length, equals(1));
      expect(options[5].value[0].runtimeType, equals(LiteralElement));
      expect(options[5].value[0].type, equals(ElementType.literal));
      expect(options[5].value[0].value, equals('other message with > sign.'));
    });
  });

  group('Gender messages', () {
    test(
        'Test gender message with all gender forms when gender forms have plain text',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Hi woman!} male {Hi man!} other {Hi there!}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Hi woman!'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Hi man!'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Hi there!'));
    });

    test(
        'Test gender message with all gender forms when gender forms are empty',
        () {
      var response =
          IcuParser().parse('{gender, select, female {} male {} other {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));
    });

    test(
        'Test gender message with all gender forms when there are no whitespace around gender forms',
        () {
      var response = IcuParser().parse(
          '{gender,select,female{Hi woman!}male{Hi man!}other{Hi there!}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Hi woman!'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Hi man!'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Hi there!'));
    });

    test(
        'Test gender message with all gender forms when gender forms have placeholder',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Miss {firstName}.} male {Mister {firstName}.} other {User {firstName}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Miss '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals('.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mister '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('User '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals('.'));
    });

    test(
        'Test gender message with all gender forms when gender forms have few placeholders',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {Miss {firstName} {lastName} from {address}.} male {Mister {firstName} {lastName} from {address}.} other {User {firstName} {lastName} from {address}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(7));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Miss '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' '));
      expect(options[0].value[3].runtimeType, equals(ArgumentElement));
      expect(options[0].value[3].type, equals(ElementType.argument));
      expect(options[0].value[3].value, equals('lastName'));
      expect(options[0].value[4].runtimeType, equals(LiteralElement));
      expect(options[0].value[4].type, equals(ElementType.literal));
      expect(options[0].value[4].value, equals(' from '));
      expect(options[0].value[5].runtimeType, equals(ArgumentElement));
      expect(options[0].value[5].type, equals(ElementType.argument));
      expect(options[0].value[5].value, equals('address'));
      expect(options[0].value[6].runtimeType, equals(LiteralElement));
      expect(options[0].value[6].type, equals(ElementType.literal));
      expect(options[0].value[6].value, equals('.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(7));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mister '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' '));
      expect(options[1].value[3].runtimeType, equals(ArgumentElement));
      expect(options[1].value[3].type, equals(ElementType.argument));
      expect(options[1].value[3].value, equals('lastName'));
      expect(options[1].value[4].runtimeType, equals(LiteralElement));
      expect(options[1].value[4].type, equals(ElementType.literal));
      expect(options[1].value[4].value, equals(' from '));
      expect(options[1].value[5].runtimeType, equals(ArgumentElement));
      expect(options[1].value[5].type, equals(ElementType.argument));
      expect(options[1].value[5].value, equals('address'));
      expect(options[1].value[6].runtimeType, equals(LiteralElement));
      expect(options[1].value[6].type, equals(ElementType.literal));
      expect(options[1].value[6].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(7));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('User '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' '));
      expect(options[2].value[3].runtimeType, equals(ArgumentElement));
      expect(options[2].value[3].type, equals(ElementType.argument));
      expect(options[2].value[3].value, equals('lastName'));
      expect(options[2].value[4].runtimeType, equals(LiteralElement));
      expect(options[2].value[4].type, equals(ElementType.literal));
      expect(options[2].value[4].value, equals(' from '));
      expect(options[2].value[5].runtimeType, equals(ArgumentElement));
      expect(options[2].value[5].type, equals(ElementType.argument));
      expect(options[2].value[5].value, equals('address'));
      expect(options[2].value[6].runtimeType, equals(LiteralElement));
      expect(options[2].value[6].type, equals(ElementType.literal));
      expect(options[2].value[6].value, equals('.'));
    });

    test(
        'Test gender message with all gender forms when gender forms have plural message',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {She has {count, plural, one {one apple} other {{count} apples}}} male {He has {count, plural, one {one apple} other {{count} apples}}} other {Person has {count, plural, one {one apple} other {{count} apples}}}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('She has '));
      expect(options[0].value[1].runtimeType, equals(PluralElement));
      expect(options[0].value[1].type, equals(ElementType.plural));
      expect(options[0].value[1].value, equals('count'));

      var genFemalePluOpt = (options[0].value[1] as PluralElement).options;

      expect(genFemalePluOpt.length, equals(2));
      expect(genFemalePluOpt[0].name, equals('one'));
      expect(genFemalePluOpt[0].value.length, equals(1));
      expect(genFemalePluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genFemalePluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genFemalePluOpt[0].value[0].value, equals('one apple'));
      expect(genFemalePluOpt[1].name, equals('other'));
      expect(genFemalePluOpt[1].value.length, equals(2));
      expect(genFemalePluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genFemalePluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genFemalePluOpt[1].value[0].value, equals('count'));
      expect(genFemalePluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genFemalePluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genFemalePluOpt[1].value[1].value, equals(' apples'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('He has '));
      expect(options[1].value[1].runtimeType, equals(PluralElement));
      expect(options[1].value[1].type, equals(ElementType.plural));
      expect(options[1].value[1].value, equals('count'));

      var genMalePluOpt = (options[1].value[1] as PluralElement).options;

      expect(genMalePluOpt.length, equals(2));
      expect(genMalePluOpt[0].name, equals('one'));
      expect(genMalePluOpt[0].value.length, equals(1));
      expect(genMalePluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genMalePluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genMalePluOpt[0].value[0].value, equals('one apple'));
      expect(genMalePluOpt[1].name, equals('other'));
      expect(genMalePluOpt[1].value.length, equals(2));
      expect(genMalePluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genMalePluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genMalePluOpt[1].value[0].value, equals('count'));
      expect(genMalePluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genMalePluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genMalePluOpt[1].value[1].value, equals(' apples'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Person has '));
      expect(options[2].value[1].runtimeType, equals(PluralElement));
      expect(options[2].value[1].type, equals(ElementType.plural));
      expect(options[2].value[1].value, equals('count'));

      var genOtherPluOpt = (options[2].value[1] as PluralElement).options;

      expect(genOtherPluOpt.length, equals(2));
      expect(genOtherPluOpt[0].name, equals('one'));
      expect(genOtherPluOpt[0].value.length, equals(1));
      expect(genOtherPluOpt[0].value[0].runtimeType, equals(LiteralElement));
      expect(genOtherPluOpt[0].value[0].type, equals(ElementType.literal));
      expect(genOtherPluOpt[0].value[0].value, equals('one apple'));
      expect(genOtherPluOpt[1].name, equals('other'));
      expect(genOtherPluOpt[1].value.length, equals(2));
      expect(genOtherPluOpt[1].value[0].runtimeType, equals(ArgumentElement));
      expect(genOtherPluOpt[1].value[0].type, equals(ElementType.argument));
      expect(genOtherPluOpt[1].value[0].value, equals('count'));
      expect(genOtherPluOpt[1].value[1].runtimeType, equals(LiteralElement));
      expect(genOtherPluOpt[1].value[1].type, equals(ElementType.literal));
      expect(genOtherPluOpt[1].value[1].value, equals(' apples'));
    });

    // Note: Tags are not supported in gender messages with the current parser implementation. Use compound messages as an alternative.
    test('Test gender message with all gender forms when gender forms have tag',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {<b>female</b> message.} male {<b>male</b> message.} other {<b>other</b> message.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>female</b> message.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>male</b> message.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>other</b> message.'));
    }, skip: true);

    // Note: Tags are not supported in gender messages with the current parser implementation. Use compound messages as an alternative.
    test(
        'Test gender message with all gender forms when gender forms have placeholder and tag',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {<b>female</b> message {placeholder}.} male {<b>male</b> message {placeholder}.} other {<b>other</b> message {placeholder}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>female</b> message '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('placeholder'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals('.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>male</b> message '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('placeholder'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>other</b> message '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('placeholder'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals('.'));
    }, skip: true);

    // Note: Less-than sign is not supported in gender messages with the current parser implementation. Use compound messages as an alternative.
    test(
        'Test gender message with all gender forms when gender forms have less-than sign',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {female message with < sign.} male {male message with < sign.} other {other message with < sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('female message with < sign.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('male message with < sign.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('other message with < sign.'));
    }, skip: true);

    test(
        'Test gender message with all gender forms when gender forms have greater-than sign',
        () {
      var response = IcuParser().parse(
          '{gender, select, female {female message with > sign.} male {male message with > sign.} other {other message with > sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var options = (response?.elementAt(0) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('female'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('female message with > sign.'));

      expect(options[1].name, equals('male'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('male message with > sign.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('other message with > sign.'));
    });
  });

  group('Select messages', () {
    test('Test select message when select forms have plain text', () {
      var response = IcuParser().parse(
          '{choice, select, foo {This is foo option} bar {This is bar option} baz {This is baz option}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option'));
    });

    test('Test select message when select forms are empty', () {
      var response =
          IcuParser().parse('{choice, select, foo {} bar {} baz {}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals(''));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals(''));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals(''));
    });

    test('Test select message when there are no whitespace around select forms',
        () {
      var response = IcuParser().parse(
          '{choice,select,foo{This is foo option}bar{This is bar option}baz{This is baz option}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option'));
    });

    test('Test select message when select forms have placeholder', () {
      var response = IcuParser().parse(
          '{choice, select, foo {This is foo option with {name} placeholder} bar {This is bar option with {name} placeholder} baz {This is baz option with {name} placeholder}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('This is foo option with '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' placeholder'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('This is bar option with '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' placeholder'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('This is baz option with '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' placeholder'));
    });

    test('Test select message when select forms have few placeholders', () {
      var response = IcuParser().parse(
          '{choice, select, foo {Foo: {firstName} {lastName}} bar {Bar: {firstName} {lastName}} baz {Baz: {firstName} {lastName}}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(4));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Foo: '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('firstName'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals(' '));
      expect(options[0].value[3].runtimeType, equals(ArgumentElement));
      expect(options[0].value[3].type, equals(ElementType.argument));
      expect(options[0].value[3].value, equals('lastName'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(4));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Bar: '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('firstName'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals(' '));
      expect(options[1].value[3].runtimeType, equals(ArgumentElement));
      expect(options[1].value[3].type, equals(ElementType.argument));
      expect(options[1].value[3].value, equals('lastName'));

      expect(options[2].name, equals('baz'));
      expect(options[2].value.length, equals(4));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('Baz: '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('firstName'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals(' '));
      expect(options[2].value[3].runtimeType, equals(ArgumentElement));
      expect(options[2].value[3].type, equals(ElementType.argument));
      expect(options[2].value[3].value, equals('lastName'));
    });

    // Note: Tags are not supported in select messages with the current parser implementation. Use compound messages as an alternative.
    test('Test select message when select forms have tag', () {
      var response = IcuParser().parse(
          '{choice, select, foo {<b>foo</b> message.} bar {<b>bar</b> message.} other {<b>other</b> message.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>foo</b> message.'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>bar</b> message.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>other</b> message.'));
    }, skip: true);

    // Note: Tags are not supported in select messages with the current parser implementation. Use compound messages as an alternative.
    test('Test select message when select forms have placeholder and tag', () {
      var response = IcuParser().parse(
          '{choice, select, foo {<b>foo</b> message {placeholder}.} bar {<b>bar</b> message {placeholder}.} other {<b>other</b> message {placeholder}.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(3));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('<b>foo</b> message '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('placeholder'));
      expect(options[0].value[2].runtimeType, equals(LiteralElement));
      expect(options[0].value[2].type, equals(ElementType.literal));
      expect(options[0].value[2].value, equals('.'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(3));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('<b>bar</b> message '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('placeholder'));
      expect(options[1].value[2].runtimeType, equals(LiteralElement));
      expect(options[1].value[2].type, equals(ElementType.literal));
      expect(options[1].value[2].value, equals('.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(3));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('<b>other</b> message '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('placeholder'));
      expect(options[2].value[2].runtimeType, equals(LiteralElement));
      expect(options[2].value[2].type, equals(ElementType.literal));
      expect(options[2].value[2].value, equals('.'));
    }, skip: true);

    // Note: Less-than sign is not supported in select messages with the current parser implementation. Use compound messages as an alternative.
    test('Test select message when select forms have less-than sign', () {
      var response = IcuParser().parse(
          '{choice, select, foo {foo message with < sign.} bar {bar message with < sign.} other {other message with < sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('foo message with < sign.'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('bar message with < sign.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('other message with < sign.'));
    }, skip: true);

    test('Test select message when select forms have greater-than sign', () {
      var response = IcuParser().parse(
          '{choice, select, foo {foo message with > sign.} bar {bar message with > sign.} other {other message with > sign.}}');

      expect(response, isNotNull);
      expect(response?.length, equals(1));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice'));

      var options = (response?.elementAt(0) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('foo'));
      expect(options[0].value.length, equals(1));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('foo message with > sign.'));

      expect(options[1].name, equals('bar'));
      expect(options[1].value.length, equals(1));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('bar message with > sign.'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(1));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('other message with > sign.'));
    });
  });

  group('Compound messages', () {
    test('Test compound message of literal and plural', () {
      var response = IcuParser().parse(
          'John has {count, plural, one {{count} apple} other {{count} apples}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('John has '));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count'));

      var options = (response?.elementAt(1) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and plural with a tag', () {
      var response = IcuParser().parse(
          'The <b>John</b> has {count, plural, one {{count} apple} other {{count} apples}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The <b>John</b> has '));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count'));

      var options = (response?.elementAt(1) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and plural wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>The <b>John</b> has {count, plural, one {{count} apple} other {{count} apples}}.</p>');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>The <b>John</b> has '));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count'));

      var options = (response?.elementAt(1) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.</p>'));
    });

    test('Test compound message of literal and gender', () {
      var response = IcuParser().parse(
          'Welcome {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('Welcome '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and gender with a tag', () {
      var response = IcuParser().parse(
          '<b>Welcome</b> {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<b>Welcome</b> '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and gender wrapped with tag', () {
      var response = IcuParser().parse(
          '<p><b>Welcome</b> {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}}.</p>');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p><b>Welcome</b> '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.</p>'));
    });

    test('Test compound message of literal and select', () {
      var response = IcuParser().parse(
          'The {choice, select, admin {admin {name}} owner {owner {name}} other {user {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('admin'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('admin '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('owner'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('owner '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('user '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and select with a tag', () {
      var response = IcuParser().parse(
          '<b>The</b> {choice, select, admin {admin {name}} owner {owner {name}} other {user {name}}}.');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<b>The</b> '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('admin'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('admin '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('owner'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('owner '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('user '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.'));
    });

    test('Test compound message of literal and select wrapped with tag', () {
      var response = IcuParser().parse(
          '<p><b>The</b> {choice, select, admin {admin {name}} owner {owner {name}} other {user {name}}}.</p>');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p><b>The</b> '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('admin'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('admin '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('owner'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('owner '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('user '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('.</p>'));
    });

    test('Test compound message of argument and plural', () {
      var response = IcuParser().parse(
          '{name} has {count, plural, one {{count} apple} other {{count} apples}} in the bag.');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(0).type, equals(ElementType.argument));
      expect(response?.elementAt(0).value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' has '));

      expect(response?.elementAt(2).runtimeType, equals(PluralElement));
      expect(response?.elementAt(2).type, equals(ElementType.plural));
      expect(response?.elementAt(2).value, equals('count'));

      var options = (response?.elementAt(2) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' in the bag.'));
    });

    test('Test compound message of argument and plural with a tag', () {
      var response = IcuParser().parse(
          'The <b>{name}</b> has {count, plural, one {{count} apple} other {{count} apples}} in the bag.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The <b>'));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('</b> has '));

      expect(response?.elementAt(3).runtimeType, equals(PluralElement));
      expect(response?.elementAt(3).type, equals(ElementType.plural));
      expect(response?.elementAt(3).value, equals('count'));

      var options = (response?.elementAt(3) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' in the bag.'));
    });

    test('Test compound message of argument and plural wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>The <b>{name}</b> has {count, plural, one {{count} apple} other {{count} apples}} in the bag.</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>The <b>'));

      expect(response?.elementAt(1).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(1).type, equals(ElementType.argument));
      expect(response?.elementAt(1).value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals('</b> has '));

      expect(response?.elementAt(3).runtimeType, equals(PluralElement));
      expect(response?.elementAt(3).type, equals(ElementType.plural));
      expect(response?.elementAt(3).value, equals('count'));

      var options = (response?.elementAt(3) as PluralElement).options;

      expect(options.length, equals(2));

      expect(options[0].name, equals('one'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('count'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' apple'));

      expect(options[1].name, equals('other'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('count'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' in the bag.</p>'));
    });

    test('Test compound message of argument and gender', () {
      var response = IcuParser().parse(
          'The {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} has the {device}.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' has the '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('device'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('.'));
    });

    test('Test compound message of argument and gender with a tag', () {
      var response = IcuParser().parse(
          'The {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} has the <b>{device}</b>.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' has the <b>'));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('device'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('</b>.'));
    });

    test('Test compound message of argument and gender wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>The {gender, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} has the <b>{device}</b>.</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>The '));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender'));

      var options = (response?.elementAt(1) as GenderElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('male'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(LiteralElement));
      expect(options[0].value[0].type, equals(ElementType.literal));
      expect(options[0].value[0].value, equals('Mr '));
      expect(options[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options[0].value[1].type, equals(ElementType.argument));
      expect(options[0].value[1].value, equals('name'));

      expect(options[1].name, equals('female'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(LiteralElement));
      expect(options[1].value[0].type, equals(ElementType.literal));
      expect(options[1].value[0].value, equals('Mrs '));
      expect(options[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options[1].value[1].type, equals(ElementType.argument));
      expect(options[1].value[1].value, equals('name'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(LiteralElement));
      expect(options[2].value[0].type, equals(ElementType.literal));
      expect(options[2].value[0].value, equals('dear '));
      expect(options[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options[2].value[1].type, equals(ElementType.argument));
      expect(options[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' has the <b>'));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('device'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('</b>.</p>'));
    });

    test('Test compound message of argument and select', () {
      var response = IcuParser().parse(
          'The one {choice, select, coffee {{name} coffee} tea {{name} tea} other {{name} drink}} please for the {client}.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The one '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('coffee'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('name'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' coffee'));

      expect(options[1].name, equals('tea'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('name'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' tea'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('name'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' drink'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' please for the '));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('client'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('.'));
    });

    test('Test compound message of argument and select with a tag', () {
      var response = IcuParser().parse(
          'The one {choice, select, coffee {{name} coffee} tea {{name} tea} other {{name} drink}} please for the <b>{client}</b>.');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('The one '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('coffee'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('name'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' coffee'));

      expect(options[1].name, equals('tea'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('name'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' tea'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('name'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' drink'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' please for the <b>'));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('client'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('</b>.'));
    });

    test('Test compound message of argument and select wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>The one {choice, select, coffee {{name} coffee} tea {{name} tea} other {{name} drink}} please for the <b>{client}</b>.</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>The one '));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice'));

      var options = (response?.elementAt(1) as SelectElement).options;

      expect(options.length, equals(3));

      expect(options[0].name, equals('coffee'));
      expect(options[0].value.length, equals(2));
      expect(options[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options[0].value[0].type, equals(ElementType.argument));
      expect(options[0].value[0].value, equals('name'));
      expect(options[0].value[1].runtimeType, equals(LiteralElement));
      expect(options[0].value[1].type, equals(ElementType.literal));
      expect(options[0].value[1].value, equals(' coffee'));

      expect(options[1].name, equals('tea'));
      expect(options[1].value.length, equals(2));
      expect(options[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options[1].value[0].type, equals(ElementType.argument));
      expect(options[1].value[0].value, equals('name'));
      expect(options[1].value[1].runtimeType, equals(LiteralElement));
      expect(options[1].value[1].type, equals(ElementType.literal));
      expect(options[1].value[1].value, equals(' tea'));

      expect(options[2].name, equals('other'));
      expect(options[2].value.length, equals(2));
      expect(options[2].value[0].runtimeType, equals(ArgumentElement));
      expect(options[2].value[0].type, equals(ElementType.argument));
      expect(options[2].value[0].value, equals('name'));
      expect(options[2].value[1].runtimeType, equals(LiteralElement));
      expect(options[2].value[1].type, equals(ElementType.literal));
      expect(options[2].value[1].value, equals(' drink'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' please for the <b>'));

      expect(response?.elementAt(3).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(3).type, equals(ElementType.argument));
      expect(response?.elementAt(3).value, equals('client'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('</b>.</p>'));
    });

    test('Test compound message of two plurals', () {
      var response = IcuParser().parse(
          '{count1, plural, one {{count1} apple} other {{count1} apples}}{count2, plural, one {{count2} orange} other {{count2} oranges}}');

      expect(response?.length, equals(2));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count1'));

      var options1 = (response?.elementAt(0) as PluralElement).options;

      expect(options1.length, equals(2));

      expect(options1[0].name, equals('one'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[0].type, equals(ElementType.argument));
      expect(options1[0].value[0].value, equals('count1'));
      expect(options1[0].value[1].runtimeType, equals(LiteralElement));
      expect(options1[0].value[1].type, equals(ElementType.literal));
      expect(options1[0].value[1].value, equals(' apple'));

      expect(options1[1].name, equals('other'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[0].type, equals(ElementType.argument));
      expect(options1[1].value[0].value, equals('count1'));
      expect(options1[1].value[1].runtimeType, equals(LiteralElement));
      expect(options1[1].value[1].type, equals(ElementType.literal));
      expect(options1[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count2'));

      var options2 = (response?.elementAt(1) as PluralElement).options;

      expect(options2.length, equals(2));

      expect(options2[0].name, equals('one'));
      expect(options2[0].value.length, equals(2));
      expect(options2[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[0].value[0].type, equals(ElementType.argument));
      expect(options2[0].value[0].value, equals('count2'));
      expect(options2[0].value[1].runtimeType, equals(LiteralElement));
      expect(options2[0].value[1].type, equals(ElementType.literal));
      expect(options2[0].value[1].value, equals(' orange'));

      expect(options2[1].name, equals('other'));
      expect(options2[1].value.length, equals(2));
      expect(options2[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[1].value[0].type, equals(ElementType.argument));
      expect(options2[1].value[0].value, equals('count2'));
      expect(options2[1].value[1].runtimeType, equals(LiteralElement));
      expect(options2[1].value[1].type, equals(ElementType.literal));
      expect(options2[1].value[1].value, equals(' oranges'));
    });

    test('Test compound message of two plurals and plain text', () {
      var response = IcuParser().parse(
          '{count1, plural, one {{count1} apple} other {{count1} apples}} and {count2, plural, one {{count2} orange} other {{count2} oranges}}');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count1'));

      var options1 = (response?.elementAt(0) as PluralElement).options;

      expect(options1.length, equals(2));

      expect(options1[0].name, equals('one'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[0].type, equals(ElementType.argument));
      expect(options1[0].value[0].value, equals('count1'));
      expect(options1[0].value[1].runtimeType, equals(LiteralElement));
      expect(options1[0].value[1].type, equals(ElementType.literal));
      expect(options1[0].value[1].value, equals(' apple'));

      expect(options1[1].name, equals('other'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[0].type, equals(ElementType.argument));
      expect(options1[1].value[0].value, equals('count1'));
      expect(options1[1].value[1].runtimeType, equals(LiteralElement));
      expect(options1[1].value[1].type, equals(ElementType.literal));
      expect(options1[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' and '));

      expect(response?.elementAt(2).runtimeType, equals(PluralElement));
      expect(response?.elementAt(2).type, equals(ElementType.plural));
      expect(response?.elementAt(2).value, equals('count2'));

      var options2 = (response?.elementAt(2) as PluralElement).options;

      expect(options2.length, equals(2));

      expect(options2[0].name, equals('one'));
      expect(options2[0].value.length, equals(2));
      expect(options2[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[0].value[0].type, equals(ElementType.argument));
      expect(options2[0].value[0].value, equals('count2'));
      expect(options2[0].value[1].runtimeType, equals(LiteralElement));
      expect(options2[0].value[1].type, equals(ElementType.literal));
      expect(options2[0].value[1].value, equals(' orange'));

      expect(options2[1].name, equals('other'));
      expect(options2[1].value.length, equals(2));
      expect(options2[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[1].value[0].type, equals(ElementType.argument));
      expect(options2[1].value[0].value, equals('count2'));
      expect(options2[1].value[1].runtimeType, equals(LiteralElement));
      expect(options2[1].value[1].type, equals(ElementType.literal));
      expect(options2[1].value[1].value, equals(' oranges'));
    });

    test('Test compound message of two plurals with a tag', () {
      var response = IcuParser().parse(
          '{count1, plural, one {{count1} apple} other {{count1} apples}} <b>and</b> {count2, plural, one {{count2} orange} other {{count2} oranges}}');

      expect(response?.length, equals(3));
      expect(response?.elementAt(0).runtimeType, equals(PluralElement));
      expect(response?.elementAt(0).type, equals(ElementType.plural));
      expect(response?.elementAt(0).value, equals('count1'));

      var options1 = (response?.elementAt(0) as PluralElement).options;

      expect(options1.length, equals(2));

      expect(options1[0].name, equals('one'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[0].type, equals(ElementType.argument));
      expect(options1[0].value[0].value, equals('count1'));
      expect(options1[0].value[1].runtimeType, equals(LiteralElement));
      expect(options1[0].value[1].type, equals(ElementType.literal));
      expect(options1[0].value[1].value, equals(' apple'));

      expect(options1[1].name, equals('other'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[0].type, equals(ElementType.argument));
      expect(options1[1].value[0].value, equals('count1'));
      expect(options1[1].value[1].runtimeType, equals(LiteralElement));
      expect(options1[1].value[1].type, equals(ElementType.literal));
      expect(options1[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' <b>and</b> '));

      expect(response?.elementAt(2).runtimeType, equals(PluralElement));
      expect(response?.elementAt(2).type, equals(ElementType.plural));
      expect(response?.elementAt(2).value, equals('count2'));

      var options2 = (response?.elementAt(2) as PluralElement).options;

      expect(options2.length, equals(2));

      expect(options2[0].name, equals('one'));
      expect(options2[0].value.length, equals(2));
      expect(options2[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[0].value[0].type, equals(ElementType.argument));
      expect(options2[0].value[0].value, equals('count2'));
      expect(options2[0].value[1].runtimeType, equals(LiteralElement));
      expect(options2[0].value[1].type, equals(ElementType.literal));
      expect(options2[0].value[1].value, equals(' orange'));

      expect(options2[1].name, equals('other'));
      expect(options2[1].value.length, equals(2));
      expect(options2[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[1].value[0].type, equals(ElementType.argument));
      expect(options2[1].value[0].value, equals('count2'));
      expect(options2[1].value[1].runtimeType, equals(LiteralElement));
      expect(options2[1].value[1].type, equals(ElementType.literal));
      expect(options2[1].value[1].value, equals(' oranges'));
    });

    test('Test compound message of two plurals wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>{count1, plural, one {{count1} apple} other {{count1} apples}} <b>and</b> {count2, plural, one {{count2} orange} other {{count2} oranges}}</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>'));

      expect(response?.elementAt(1).runtimeType, equals(PluralElement));
      expect(response?.elementAt(1).type, equals(ElementType.plural));
      expect(response?.elementAt(1).value, equals('count1'));

      var options1 = (response?.elementAt(1) as PluralElement).options;

      expect(options1.length, equals(2));

      expect(options1[0].name, equals('one'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[0].type, equals(ElementType.argument));
      expect(options1[0].value[0].value, equals('count1'));
      expect(options1[0].value[1].runtimeType, equals(LiteralElement));
      expect(options1[0].value[1].type, equals(ElementType.literal));
      expect(options1[0].value[1].value, equals(' apple'));

      expect(options1[1].name, equals('other'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[0].type, equals(ElementType.argument));
      expect(options1[1].value[0].value, equals('count1'));
      expect(options1[1].value[1].runtimeType, equals(LiteralElement));
      expect(options1[1].value[1].type, equals(ElementType.literal));
      expect(options1[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' <b>and</b> '));

      expect(response?.elementAt(3).runtimeType, equals(PluralElement));
      expect(response?.elementAt(3).type, equals(ElementType.plural));
      expect(response?.elementAt(3).value, equals('count2'));

      var options2 = (response?.elementAt(3) as PluralElement).options;

      expect(options2.length, equals(2));

      expect(options2[0].name, equals('one'));
      expect(options2[0].value.length, equals(2));
      expect(options2[0].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[0].value[0].type, equals(ElementType.argument));
      expect(options2[0].value[0].value, equals('count2'));
      expect(options2[0].value[1].runtimeType, equals(LiteralElement));
      expect(options2[0].value[1].type, equals(ElementType.literal));
      expect(options2[0].value[1].value, equals(' orange'));

      expect(options2[1].name, equals('other'));
      expect(options2[1].value.length, equals(2));
      expect(options2[1].value[0].runtimeType, equals(ArgumentElement));
      expect(options2[1].value[0].type, equals(ElementType.argument));
      expect(options2[1].value[0].value, equals('count2'));
      expect(options2[1].value[1].runtimeType, equals(LiteralElement));
      expect(options2[1].value[1].type, equals(ElementType.literal));
      expect(options2[1].value[1].value, equals(' oranges'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals('</p>'));
    });

    test('Test compound message of two genders', () {
      var response = IcuParser().parse(
          '{gender1, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} and {gender2, select, male {his} female {her} other {its}} cat');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender1'));

      var options1 = (response?.elementAt(0) as GenderElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('male'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('Mr '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('female'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('Mrs '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('dear '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' and '));

      expect(response?.elementAt(2).runtimeType, equals(GenderElement));
      expect(response?.elementAt(2).type, equals(ElementType.gender));
      expect(response?.elementAt(2).value, equals('gender2'));

      var options2 = (response?.elementAt(2) as GenderElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('male'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('his'));

      expect(options2[1].name, equals('female'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('her'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('its'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' cat'));
    });

    test('Test compound message of two genders with a tag', () {
      var response = IcuParser().parse(
          '{gender1, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} <b>and</b> {gender2, select, male {his} female {her} other {its}} cat');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender1'));

      var options1 = (response?.elementAt(0) as GenderElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('male'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('Mr '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('female'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('Mrs '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('dear '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' <b>and</b> '));

      expect(response?.elementAt(2).runtimeType, equals(GenderElement));
      expect(response?.elementAt(2).type, equals(ElementType.gender));
      expect(response?.elementAt(2).value, equals('gender2'));

      var options2 = (response?.elementAt(2) as GenderElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('male'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('his'));

      expect(options2[1].name, equals('female'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('her'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('its'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' cat'));
    });

    test('Test compound message of two genders wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>{gender1, select, male {Mr {name}} female {Mrs {name}} other {dear {name}}} <b>and</b> {gender2, select, male {his} female {her} other {its}} cat</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>'));

      expect(response?.elementAt(1).runtimeType, equals(GenderElement));
      expect(response?.elementAt(1).type, equals(ElementType.gender));
      expect(response?.elementAt(1).value, equals('gender1'));

      var options1 = (response?.elementAt(1) as GenderElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('male'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('Mr '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('female'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('Mrs '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('dear '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' <b>and</b> '));

      expect(response?.elementAt(3).runtimeType, equals(GenderElement));
      expect(response?.elementAt(3).type, equals(ElementType.gender));
      expect(response?.elementAt(3).value, equals('gender2'));

      var options2 = (response?.elementAt(3) as GenderElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('male'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('his'));

      expect(options2[1].name, equals('female'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('her'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('its'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' cat</p>'));
    });

    test('Test compound message of two selects', () {
      var response = IcuParser().parse(
          '{choice1, select, admin {admin {name}} owner {owner {name}} other {user {name}}} with {choice2, select, IELTS {IELTS level} TOEFL {TOEFL level} other {Academic level}} of English');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice1'));

      var options1 = (response?.elementAt(0) as SelectElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('admin'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('admin '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('owner'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('owner '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('user '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' with '));

      expect(response?.elementAt(2).runtimeType, equals(SelectElement));
      expect(response?.elementAt(2).type, equals(ElementType.select));
      expect(response?.elementAt(2).value, equals('choice2'));

      var options2 = (response?.elementAt(2) as SelectElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('IELTS'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('IELTS level'));

      expect(options2[1].name, equals('TOEFL'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('TOEFL level'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('Academic level'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' of English'));
    });

    test('Test compound message of two selects with a tag', () {
      var response = IcuParser().parse(
          '{choice1, select, admin {admin {name}} owner {owner {name}} other {user {name}}} <b>with</b> {choice2, select, IELTS {IELTS level} TOEFL {TOEFL level} other {Academic level}} of English');

      expect(response?.length, equals(4));
      expect(response?.elementAt(0).runtimeType, equals(SelectElement));
      expect(response?.elementAt(0).type, equals(ElementType.select));
      expect(response?.elementAt(0).value, equals('choice1'));

      var options1 = (response?.elementAt(0) as SelectElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('admin'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('admin '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('owner'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('owner '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('user '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' <b>with</b> '));

      expect(response?.elementAt(2).runtimeType, equals(SelectElement));
      expect(response?.elementAt(2).type, equals(ElementType.select));
      expect(response?.elementAt(2).value, equals('choice2'));

      var options2 = (response?.elementAt(2) as SelectElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('IELTS'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('IELTS level'));

      expect(options2[1].name, equals('TOEFL'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('TOEFL level'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('Academic level'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' of English'));
    });

    test('Test compound message of two selects wrapped with tag', () {
      var response = IcuParser().parse(
          '<p>{choice1, select, admin {admin {name}} owner {owner {name}} other {user {name}}} <b>with</b> {choice2, select, IELTS {IELTS level} TOEFL {TOEFL level} other {Academic level}} of English</p>');

      expect(response?.length, equals(5));
      expect(response?.elementAt(0).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(0).type, equals(ElementType.literal));
      expect(response?.elementAt(0).value, equals('<p>'));

      expect(response?.elementAt(1).runtimeType, equals(SelectElement));
      expect(response?.elementAt(1).type, equals(ElementType.select));
      expect(response?.elementAt(1).value, equals('choice1'));

      var options1 = (response?.elementAt(1) as SelectElement).options;

      expect(options1.length, equals(3));

      expect(options1[0].name, equals('admin'));
      expect(options1[0].value.length, equals(2));
      expect(options1[0].value[0].runtimeType, equals(LiteralElement));
      expect(options1[0].value[0].type, equals(ElementType.literal));
      expect(options1[0].value[0].value, equals('admin '));
      expect(options1[0].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[0].value[1].type, equals(ElementType.argument));
      expect(options1[0].value[1].value, equals('name'));

      expect(options1[1].name, equals('owner'));
      expect(options1[1].value.length, equals(2));
      expect(options1[1].value[0].runtimeType, equals(LiteralElement));
      expect(options1[1].value[0].type, equals(ElementType.literal));
      expect(options1[1].value[0].value, equals('owner '));
      expect(options1[1].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[1].value[1].type, equals(ElementType.argument));
      expect(options1[1].value[1].value, equals('name'));

      expect(options1[2].name, equals('other'));
      expect(options1[2].value.length, equals(2));
      expect(options1[2].value[0].runtimeType, equals(LiteralElement));
      expect(options1[2].value[0].type, equals(ElementType.literal));
      expect(options1[2].value[0].value, equals('user '));
      expect(options1[2].value[1].runtimeType, equals(ArgumentElement));
      expect(options1[2].value[1].type, equals(ElementType.argument));
      expect(options1[2].value[1].value, equals('name'));

      expect(response?.elementAt(2).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(2).type, equals(ElementType.literal));
      expect(response?.elementAt(2).value, equals(' <b>with</b> '));

      expect(response?.elementAt(3).runtimeType, equals(SelectElement));
      expect(response?.elementAt(3).type, equals(ElementType.select));
      expect(response?.elementAt(3).value, equals('choice2'));

      var options2 = (response?.elementAt(3) as SelectElement).options;

      expect(options2.length, equals(3));

      expect(options2[0].name, equals('IELTS'));
      expect(options2[0].value.length, equals(1));
      expect(options2[0].value[0].runtimeType, equals(LiteralElement));
      expect(options2[0].value[0].type, equals(ElementType.literal));
      expect(options2[0].value[0].value, equals('IELTS level'));

      expect(options2[1].name, equals('TOEFL'));
      expect(options2[1].value.length, equals(1));
      expect(options2[1].value[0].runtimeType, equals(LiteralElement));
      expect(options2[1].value[0].type, equals(ElementType.literal));
      expect(options2[1].value[0].value, equals('TOEFL level'));

      expect(options2[2].name, equals('other'));
      expect(options2[2].value.length, equals(1));
      expect(options2[2].value[0].runtimeType, equals(LiteralElement));
      expect(options2[2].value[0].type, equals(ElementType.literal));
      expect(options2[2].value[0].value, equals('Academic level'));

      expect(response?.elementAt(4).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(4).type, equals(ElementType.literal));
      expect(response?.elementAt(4).value, equals(' of English</p>'));
    });

    test('Test compound message with a less-than sign', () {
      var response = IcuParser().parse(
          '{gender, select, male {Mr} female {Mrs} other {User}} {name} has < {count, plural, one {{count} apple} other {{count} apples}}.');

      expect(response?.length, equals(6));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var genderOptions = (response?.elementAt(0) as GenderElement).options;

      expect(genderOptions.length, equals(3));

      expect(genderOptions[0].name, equals('male'));
      expect(genderOptions[0].value.length, equals(1));
      expect(genderOptions[0].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[0].value[0].type, equals(ElementType.literal));
      expect(genderOptions[0].value[0].value, equals('Mr'));

      expect(genderOptions[1].name, equals('female'));
      expect(genderOptions[1].value.length, equals(1));
      expect(genderOptions[1].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[1].value[0].type, equals(ElementType.literal));
      expect(genderOptions[1].value[0].value, equals('Mrs'));

      expect(genderOptions[2].name, equals('other'));
      expect(genderOptions[2].value.length, equals(1));
      expect(genderOptions[2].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[2].value[0].type, equals(ElementType.literal));
      expect(genderOptions[2].value[0].value, equals('User'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' '));

      expect(response?.elementAt(2).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(2).type, equals(ElementType.argument));
      expect(response?.elementAt(2).value, equals('name'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' has < '));

      expect(response?.elementAt(4).runtimeType, equals(PluralElement));
      expect(response?.elementAt(4).type, equals(ElementType.plural));
      expect(response?.elementAt(4).value, equals('count'));

      var pluralOptions = (response?.elementAt(4) as PluralElement).options;

      expect(pluralOptions.length, equals(2));

      expect(pluralOptions[0].name, equals('one'));
      expect(pluralOptions[0].value.length, equals(2));
      expect(pluralOptions[0].value[0].runtimeType, equals(ArgumentElement));
      expect(pluralOptions[0].value[0].type, equals(ElementType.argument));
      expect(pluralOptions[0].value[0].value, equals('count'));
      expect(pluralOptions[0].value[1].runtimeType, equals(LiteralElement));
      expect(pluralOptions[0].value[1].type, equals(ElementType.literal));
      expect(pluralOptions[0].value[1].value, equals(' apple'));

      expect(pluralOptions[1].name, equals('other'));
      expect(pluralOptions[1].value.length, equals(2));
      expect(pluralOptions[1].value[0].runtimeType, equals(ArgumentElement));
      expect(pluralOptions[1].value[0].type, equals(ElementType.argument));
      expect(pluralOptions[1].value[0].value, equals('count'));
      expect(pluralOptions[1].value[1].runtimeType, equals(LiteralElement));
      expect(pluralOptions[1].value[1].type, equals(ElementType.literal));
      expect(pluralOptions[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(response?.elementAt(5).value, equals('.'));
    });

    test('Test compound message with a greater-than sign', () {
      var response = IcuParser().parse(
          '{gender, select, male {Mr} female {Mrs} other {User}} {name} has > {count, plural, one {{count} apple} other {{count} apples}}.');

      expect(response?.length, equals(6));
      expect(response?.elementAt(0).runtimeType, equals(GenderElement));
      expect(response?.elementAt(0).type, equals(ElementType.gender));
      expect(response?.elementAt(0).value, equals('gender'));

      var genderOptions = (response?.elementAt(0) as GenderElement).options;

      expect(genderOptions.length, equals(3));

      expect(genderOptions[0].name, equals('male'));
      expect(genderOptions[0].value.length, equals(1));
      expect(genderOptions[0].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[0].value[0].type, equals(ElementType.literal));
      expect(genderOptions[0].value[0].value, equals('Mr'));

      expect(genderOptions[1].name, equals('female'));
      expect(genderOptions[1].value.length, equals(1));
      expect(genderOptions[1].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[1].value[0].type, equals(ElementType.literal));
      expect(genderOptions[1].value[0].value, equals('Mrs'));

      expect(genderOptions[2].name, equals('other'));
      expect(genderOptions[2].value.length, equals(1));
      expect(genderOptions[2].value[0].runtimeType, equals(LiteralElement));
      expect(genderOptions[2].value[0].type, equals(ElementType.literal));
      expect(genderOptions[2].value[0].value, equals('User'));

      expect(response?.elementAt(1).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(1).type, equals(ElementType.literal));
      expect(response?.elementAt(1).value, equals(' '));

      expect(response?.elementAt(2).runtimeType, equals(ArgumentElement));
      expect(response?.elementAt(2).type, equals(ElementType.argument));
      expect(response?.elementAt(2).value, equals('name'));

      expect(response?.elementAt(3).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(3).type, equals(ElementType.literal));
      expect(response?.elementAt(3).value, equals(' has > '));

      expect(response?.elementAt(4).runtimeType, equals(PluralElement));
      expect(response?.elementAt(4).type, equals(ElementType.plural));
      expect(response?.elementAt(4).value, equals('count'));

      var pluralOptions = (response?.elementAt(4) as PluralElement).options;

      expect(pluralOptions.length, equals(2));

      expect(pluralOptions[0].name, equals('one'));
      expect(pluralOptions[0].value.length, equals(2));
      expect(pluralOptions[0].value[0].runtimeType, equals(ArgumentElement));
      expect(pluralOptions[0].value[0].type, equals(ElementType.argument));
      expect(pluralOptions[0].value[0].value, equals('count'));
      expect(pluralOptions[0].value[1].runtimeType, equals(LiteralElement));
      expect(pluralOptions[0].value[1].type, equals(ElementType.literal));
      expect(pluralOptions[0].value[1].value, equals(' apple'));

      expect(pluralOptions[1].name, equals('other'));
      expect(pluralOptions[1].value.length, equals(2));
      expect(pluralOptions[1].value[0].runtimeType, equals(ArgumentElement));
      expect(pluralOptions[1].value[0].type, equals(ElementType.argument));
      expect(pluralOptions[1].value[0].value, equals('count'));
      expect(pluralOptions[1].value[1].runtimeType, equals(LiteralElement));
      expect(pluralOptions[1].value[1].type, equals(ElementType.literal));
      expect(pluralOptions[1].value[1].value, equals(' apples'));

      expect(response?.elementAt(5).runtimeType, equals(LiteralElement));
      expect(response?.elementAt(5).type, equals(ElementType.literal));
      expect(response?.elementAt(5).value, equals('.'));
    });
  });
}
