import 'package:intl_utils/src/generator/label.dart';
import 'package:test/test.dart';

void main() {
  group('Label instantiation', () {
    test('Test instantiation with mandatory args', () {
      var label = Label('labelName', 'Content');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content'));
      expect(label.type, isNull);
      expect(label.description, isNull);
      expect(label.placeholders, isNull);
    });

    test('Test instantiation with all args', () {
      var label = Label('labelName', 'Content with {name} placeholder!',
          type: 'text', description: 'Description', placeholders: ['name']);

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content with {name} placeholder!'));
      expect(label.type, equals('text'));
      expect(label.description, equals('Description'));
      expect(label.placeholders?.length, equals(1));
      expect(label.placeholders?.first, equals('name'));
    });

    test('Test instantiation when content has new line set', () {
      var label = Label('labelName', 'Content with \n new line.');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content with \n new line.'));
      expect(label.type, isNull);
      expect(label.description, isNull);
      expect(label.placeholders, isNull);
    });

    test('Test instantiation when content has single quotation mark set', () {
      var label = Label('labelName', 'Content with \' single quotation mark.');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content with \' single quotation mark.'));
      expect(label.type, isNull);
      expect(label.description, isNull);
      expect(label.placeholders, isNull);
    });

    test('Test instantiation when content has dollar sign set', () {
      var label = Label('labelName', 'Content with \$ dollar sign.');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content with \$ dollar sign.'));
      expect(label.type, isNull);
      expect(label.description, isNull);
      expect(label.placeholders, isNull);
    });

    test('Test instantiation when description has new line set', () {
      var label = Label('labelName', 'Content',
          description: 'Description with \n new line');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content'));
      expect(label.type, isNull);
      expect(label.description, equals('Description with \n new line'));
      expect(label.placeholders, isNull);
    });

    test('Test instantiation when description has single quotation mark set',
        () {
      var label = Label('labelName', 'Content',
          description: 'Description with \' single quotation mark');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content'));
      expect(label.type, isNull);
      expect(label.description,
          equals('Description with \' single quotation mark'));
      expect(label.placeholders, isNull);
    });

    test('Test instantiation when description has dollar sign set', () {
      var label = Label('labelName', 'Content',
          description: 'Description with \$ dollar sign');

      expect(label.name, equals('labelName'));
      expect(label.content, equals('Content'));
      expect(label.type, isNull);
      expect(label.description, equals('Description with \$ dollar sign'));
      expect(label.placeholders, isNull);
    });
  });

  group('Invalid label properties', () {
    test('Test dart getter when name is empty string', () {
      var label = Label('', 'Content');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the '' key"));
    });

    test('Test dart getter when name is plain text', () {
      var label = Label('Some plain text', 'Content');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'Some plain text' key"));
    });

    test('Test dart getter when name does not follow naming convention', () {
      var label = Label('page.home.title', 'Content');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'page.home.title' key"));
    });

    // Note: check parser impl.
    test('Test dart getter when content has an empty placeholder', () {
      var label = Label('labelName', 'Content {} with empty placeholder');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'labelName' key"));
    });

    // Note: check parser impl.
    test('Test dart getter when content has digit placeholder', () {
      var label = Label('labelName', 'Content {0} with digit placeholder');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'labelName' key"));
    });

    // Note: check parser impl.
    test('Test dart getter when content has hash placeholder', () {
      var label = Label('labelName', 'Content {#} with hash placeholder');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'labelName' key"));
    });

    // Note: check parser impl.
    test(
        'Test dart getter when content has placeholder which name does not follow naming convention',
        () {
      var label = Label('labelName',
          'Content {invalid-placeholder-name} with invalid placeholder name');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'labelName' key"));
    });
  });

  group('Literal getters', () {
    test('Test literal dart getter with name and content set', () {
      var label = Label('labelName', 'Literal message');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter with name, content and type set', () {
      var label = Label('labelName', 'Literal message', type: 'text');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test literal dart getter with name, content, type and description set',
        () {
      var label = Label('labelName', 'Literal message',
          type: 'text', description: 'Some description');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'Some description\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when content has backtick set', () {
      var label = Label('labelName', 'Literal `message`');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal \'message\'`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal `message`\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when content has new line set', () {
      var label = Label('labelName', 'Literal message \n with new line');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message \\n with new line`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message \\n with new line\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when content has single quotation mark set',
        () {
      var label =
          Label('labelName', 'Literal message \' with single quotation mark');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message \' with single quotation mark`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message \\\' with single quotation mark\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when content has dollar sign set', () {
      var label = Label('labelName', 'Literal message \$ with dollar sign');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message \$ with dollar sign`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message \\\$ with dollar sign\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when description has new line set', () {
      var label = Label('labelName', 'Literal message',
          description: 'Description \n with new line');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'Description \\n with new line\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test literal dart getter when description has single quotation mark set',
        () {
      var label = Label('labelName', 'Literal message',
          description: 'Description \' with single quotation mark');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'Description \\\' with single quotation mark\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test literal dart getter when description has dollar sign set', () {
      var label = Label('labelName', 'Literal message',
          description: 'Description \$ with dollar sign');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Literal message`',
            '  String get labelName {',
            '    return Intl.message(',
            '      \'Literal message\',',
            '      name: \'labelName\',',
            '      desc: \'Description \\\$ with dollar sign\',',
            '      args: [],',
            '    );',
            '  }'
          ].join('\n')));
    });
  });

  group('Argument getters', () {
    test('Test argument dart getter with name and content set', () {
      var label = Label('labelName', 'Argument message {name}.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and placeholders set when placeholders are not used',
        () {
      var label =
          Label('labelName', 'Argument message', placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter with name, content and placeholders set',
        () {
      var label = Label('labelName', 'Argument message {name}.',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and the first placeholder set',
        () {
      var label = Label('labelName', 'Argument message {firstName} {lastName}.',
          placeholders: ['firstName']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName}.`',
            '  String labelName(Object firstName, Object lastName) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [firstName, lastName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and the last placeholder set',
        () {
      var label = Label('labelName', 'Argument message {firstName} {lastName}.',
          placeholders: ['lastName']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName}.`',
            '  String labelName(Object lastName, Object firstName) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [lastName, firstName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name and content set when some placeholders are repeated',
        () {
      var label = Label('labelName',
          'Argument message {firstName} {lastName} {address}, {firstName} {lastName}.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName} {address}, {firstName} {lastName}.`',
            '  String labelName(Object firstName, Object lastName, Object address) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName \$address, \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [firstName, lastName, address],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and placeholders set when some placeholders are repeated',
        () {
      var label = Label('labelName',
          'Argument message {firstName} {lastName} {address}, {firstName} {lastName}.',
          placeholders: ['firstName', 'lastName', 'address']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName} {address}, {firstName} {lastName}.`',
            '  String labelName(Object firstName, Object lastName, Object address) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName \$address, \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [firstName, lastName, address],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and the first placeholder set when some placeholders are repeated',
        () {
      var label = Label('labelName',
          'Argument message {firstName} {lastName} {address}, {firstName} {lastName}.',
          placeholders: ['firstName']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName} {address}, {firstName} {lastName}.`',
            '  String labelName(Object firstName, Object lastName, Object address) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName \$address, \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [firstName, lastName, address],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter with name, content and the last placeholder set when some placeholders are repeated',
        () {
      var label = Label('labelName',
          'Argument message {firstName} {lastName} {address}, {firstName} {lastName}.',
          placeholders: ['address']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {firstName} {lastName} {address}, {firstName} {lastName}.`',
            '  String labelName(Object address, Object firstName, Object lastName) {',
            '    return Intl.message(',
            '      \'Argument message \$firstName \$lastName \$address, \$firstName \$lastName.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [address, firstName, lastName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when content has backtick set', () {
      var label = Label('labelName', 'Argument `message` {name}.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument \'message\' {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument `message` \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when content has new line set', () {
      var label = Label('labelName', 'Argument message \n {name}.',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message \\n {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \\n \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when content has single quotation mark set',
        () {
      var label = Label('labelName', 'Argument message \' {name}.',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message \' {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \\\' \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when content has dollar sign set', () {
      var label = Label('labelName', 'Argument message \$ {name}.',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message \$ {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \\\$ \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the text',
        () {
      var label = Label('labelName', 'Argument message: before{name} after.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before{name} after.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before\$name after.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the underscore sign',
        () {
      var label = Label('labelName', 'Argument message: before _{name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before _{name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before _\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the number',
        () {
      var label = Label('labelName', 'Argument message: before 357{name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before 357{name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before 357\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the dash sign',
        () {
      var label = Label('labelName', 'Argument message: before -{name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before -{name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before -\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the dot sign',
        () {
      var label = Label('labelName', 'Argument message: before .{name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before .{name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before .\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the ampersand sign',
        () {
      var label = Label('labelName', 'Argument message: before &{name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before &{name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before &\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning with the dollar sign',
        () {
      var label = Label('labelName', 'Argument message: before \${name} .');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before \${name} .`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \\\$\$name .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the text',
        () {
      var label = Label('labelName', 'Argument message: before {name}after.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}after.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \${name}after.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the underscore sign',
        () {
      var label = Label('labelName', 'Argument message: before {name}_.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}_.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \${name}_.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the number',
        () {
      var label = Label('labelName', 'Argument message: before {name}357.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}357.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \${name}357.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the dash sign',
        () {
      var label = Label('labelName', 'Argument message: before {name}-.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}-.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \$name-.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the dot sign',
        () {
      var label = Label('labelName', 'Argument message: before {name}.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the ampersand sign',
        () {
      var label = Label('labelName', 'Argument message: before {name}&.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}&.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \$name&.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the ending with the dollar sign',
        () {
      var label = Label('labelName', 'Argument message: before {name}\$.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before {name}\$.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before \$name\\\$.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when placeholder is sticked at the beginning and on the ending with the text',
        () {
      var label = Label('labelName', 'Argument message: before{name}after.');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message: before{name}after.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message: before\${name}after.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when description has new line set', () {
      var label = Label('labelName', 'Argument message {name}.',
          description: 'Description with \n new line', placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\n new line\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test argument dart getter when description has single quotation mark set',
        () {
      var label = Label('labelName', 'Argument message {name}.',
          description: 'Description with \' single quotation mark',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\' single quotation mark\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test argument dart getter when description has dollar sign set', () {
      var label = Label('labelName', 'Argument message {name}.',
          description: 'Description with \$ dollar sign',
          placeholders: ['name']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `Argument message {name}.`',
            '  String labelName(Object name) {',
            '    return Intl.message(',
            '      \'Argument message \$name.\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\$ dollar sign\',',
            '      args: [name],',
            '    );',
            '  }'
          ].join('\n')));
    });
  });

  group('Plural getters', () {
    test('Test plural dart getter with name and content set', () {
      var label = Label(
          'labelName', '{count, plural, one {one item} other {other items}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one item} other {other items}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one item\',',
            '      other: \'other items\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter with name, content and placeholders set', () {
      var label = Label(
          'labelName', '{count, plural, one {one item} other {other items}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one item} other {other items}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one item\',',
            '      other: \'other items\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter with name, content and placeholders set for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero message} one {one message} two {two message} few {few message} many {many message} other {other message}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero message} one {one message} two {two message} few {few message} many {many message} other {other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero message\',',
            '      one: \'one message\',',
            '      two: \'two message\',',
            '      few: \'few message\',',
            '      many: \'many message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter with name, content and placeholders set for all plural forms when plural forms are empty',
        () {
      var label = Label('labelName',
          '{count, plural, zero {} one {} two {} few {} many {} other {}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {} one {} two {} few {} many {} other {}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'\',',
            '      one: \'\',',
            '      two: \'\',',
            '      few: \'\',',
            '      many: \'\',',
            '      other: \'\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has backtick set for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero `message`} one {one `message`} two {two `message`} few {few `message`} many {many `message`} other {other `message`}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero \'message\'} one {one \'message\'} two {two \'message\'} few {few \'message\'} many {many \'message\'} other {other \'message\'}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero `message`\',',
            '      one: \'one `message`\',',
            '      two: \'two `message`\',',
            '      few: \'few `message`\',',
            '      many: \'many `message`\',',
            '      other: \'other `message`\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has new line set for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero \n message} one {one \n message} two {two \n message} few {few \n message} many {many \n message} other {other \n message}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero \\n message} one {one \\n message} two {two \\n message} few {few \\n message} many {many \\n message} other {other \\n message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \\n message\',',
            '      one: \'one \\n message\',',
            '      two: \'two \\n message\',',
            '      few: \'few \\n message\',',
            '      many: \'many \\n message\',',
            '      other: \'other \\n message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has single quotation mark set for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero \' message} one {one \' message} two {two \' message} few {few \' message} many {many \' message} other {other \' message}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero \' message} one {one \' message} two {two \' message} few {few \' message} many {many \' message} other {other \' message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \\\' message\',',
            '      one: \'one \\\' message\',',
            '      two: \'two \\\' message\',',
            '      few: \'few \\\' message\',',
            '      many: \'many \\\' message\',',
            '      other: \'other \\\' message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has dollar sign set for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero \$ message} one {one \$ message} two {two \$ message} few {few \$ message} many {many \$ message} other {other \$ message}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero \$ message} one {one \$ message} two {two \$ message} few {few \$ message} many {many \$ message} other {other \$ message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \\\$ message\',',
            '      one: \'one \\\$ message\',',
            '      two: \'two \\\$ message\',',
            '      few: \'few \\\$ message\',',
            '      many: \'many \\\$ message\',',
            '      other: \'other \\\$ message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has placeholder which is sticked at the ending with the text for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero {count}abc} one {one {count}abc} two {two {count}abc} few {few {count}abc} many {many {count}abc} other {other {count}abc}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero {count}abc} one {one {count}abc} two {two {count}abc} few {few {count}abc} many {many {count}abc} other {other {count}abc}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \${count}abc\',',
            '      one: \'one \${count}abc\',',
            '      two: \'two \${count}abc\',',
            '      few: \'few \${count}abc\',',
            '      many: \'many \${count}abc\',',
            '      other: \'other \${count}abc\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has placeholder which is sticked at the ending with the underscore sign for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero {count}_ .} one {one {count}_ .} two {two {count}_ .} few {few {count}_ .} many {many {count}_ .} other {other {count}_ .}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero {count}_ .} one {one {count}_ .} two {two {count}_ .} few {few {count}_ .} many {many {count}_ .} other {other {count}_ .}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \${count}_ .\',',
            '      one: \'one \${count}_ .\',',
            '      two: \'two \${count}_ .\',',
            '      few: \'few \${count}_ .\',',
            '      many: \'many \${count}_ .\',',
            '      other: \'other \${count}_ .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has placeholder which is sticked at the ending with the number for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero {count}357 .} one {one {count}357 .} two {two {count}357 .} few {few {count}357 .} many {many {count}357 .} other {other {count}357 .}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero {count}357 .} one {one {count}357 .} two {two {count}357 .} few {few {count}357 .} many {many {count}357 .} other {other {count}357 .}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero \${count}357 .\',',
            '      one: \'one \${count}357 .\',',
            '      two: \'two \${count}357 .\',',
            '      few: \'few \${count}357 .\',',
            '      many: \'many \${count}357 .\',',
            '      other: \'other \${count}357 .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when content has placeholder which is sticked at the beginning and at the ending with the text for all plural forms',
        () {
      var label = Label('labelName',
          '{count, plural, zero {zero before{count}after.} one {one before{count}after.} two {two before{count}after.} few {few before{count}after.} many {many before{count}after.} other {other before{count}after.}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, zero {zero before{count}after.} one {one before{count}after.} two {two before{count}after.} few {few before{count}after.} many {many before{count}after.} other {other before{count}after.}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero before\${count}after.\',',
            '      one: \'one before\${count}after.\',',
            '      two: \'two before\${count}after.\',',
            '      few: \'few before\${count}after.\',',
            '      many: \'many before\${count}after.\',',
            '      other: \'other before\${count}after.\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when description has new line set', () {
      var label = Label('labelName',
          '{count, plural, one {one message} other {other message}}',
          description: 'Description with \n new line', placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one message} other {other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\n new line\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test plural dart getter when description has single quotation mark set',
        () {
      var label = Label('labelName',
          '{count, plural, one {one message} other {other message}}',
          description: 'Description with \' single quotation mark',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one message} other {other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\' single quotation mark\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when description has dollar sign set', () {
      var label = Label('labelName',
          '{count, plural, one {one message} other {other message}}',
          description: 'Description with \$ dollar sign',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one message} other {other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\$ dollar sign\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when content has additional placeholder set',
        () {
      var label = Label('labelName',
          '{count, plural, one {{name} has one item} other {{name} have {count} items}}',
          placeholders: ['count']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {{name} has one item} other {{name} have {count} items}}`',
            '  String labelName(num count, Object name) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'\$name has one item\',',
            '      other: \'\$name have \$count items\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count, name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when content has nested plural content set',
        () {
      var label = Label('labelName',
          '{cats, plural, one {one cat runs {birds, plural, one {one bird.} other {{birds} birds.}}} other {{cats} cats run {birds, plural, one {one bird.} other {{birds} birds.}}}}',
          placeholders: ['cats']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{cats, plural, one {one cat runs {birds, plural, one {one bird.} other {{birds} birds.}}} other {{cats} cats run {birds, plural, one {one bird.} other {{birds} birds.}}}}`',
            '  String labelName(num cats, Object birds) {',
            '    return Intl.plural(',
            '      cats,',
            '      one: \'one cat runs {birds, plural, one {one bird.} other {{birds} birds.}}\',',
            '      other: \'{cats} cats run {birds, plural, one {one bird.} other {{birds} birds.}}\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [cats, birds],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when content has nested gender content set',
        () {
      var label = Label('labelName',
          '{cats, plural, one {one cat runs {gender, select, male {one man} female {one woman} other {one person}}} other {{cats} cats run {gender, select, male {one man} female {one woman} other {one person}}}}',
          placeholders: ['cats']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{cats, plural, one {one cat runs {gender, select, male {one man} female {one woman} other {one person}}} other {{cats} cats run {gender, select, male {one man} female {one woman} other {one person}}}}`',
            '  String labelName(num cats, Object gender) {',
            '    return Intl.plural(',
            '      cats,',
            '      one: \'one cat runs {gender, select, male {one man} female {one woman} other {one person}}\',',
            '      other: \'{cats} cats run {gender, select, male {one man} female {one woman} other {one person}}\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [cats, gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when content has additional plural form set',
        () {
      var label = Label('labelName',
          '{count, plural, one {one message} unsupportedPluralForm {unsupported plural form message} other {other message}}');

      expect(label.generateDartGetter(),
          equals("  // skipped getter for the 'labelName' key"));
    });

    test(
        'Test plural dart getter when content has plural forms with the same meaning set',
        () {
      var label = Label('labelName',
          '{count, plural, =0 {=0 message} zero {zero message} =1 {=1 message} one {one message} =2 {=2 message} two {two message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, =0 {=0 message} zero {zero message} =1 {=1 message} one {one message} =2 {=2 message} two {two message} other {other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      zero: \'zero message\',',
            '      one: \'one message\',',
            '      two: \'two message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test plural dart getter when content has repeated plural forms set',
        () {
      var label = Label('labelName',
          '{count, plural, one {one message} one {repeated one message} other {other message} other {repeated other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{count, plural, one {one message} one {repeated one message} other {other message} other {repeated other message}}`',
            '  String labelName(num count) {',
            '    return Intl.plural(',
            '      count,',
            '      one: \'one message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [count],',
            '    );',
            '  }'
          ].join('\n')));
    });
  });

  group('Gender getters', () {
    test('Test gender dart getter with name and content set', () {
      var label = Label('labelName',
          '{gender, select, male {male message} female {female message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test gender dart getter with name, content and placeholders set', () {
      var label = Label('labelName',
          '{gender, select, male {male message} female {female message} other {other message}}',
          placeholders: ['gender']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter with name, content and placeholders set when gender forms are empty',
        () {
      var label = Label(
          'labelName', '{gender, select, male {} female {} other {}}',
          placeholders: ['gender']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {} female {} other {}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'\',',
            '      female: \'\',',
            '      other: \'\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has backtick set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male `message`} female {female `message`} other {other `message`}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male \'message\'} female {female \'message\'} other {other \'message\'}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male `message`\',',
            '      female: \'female `message`\',',
            '      other: \'other `message`\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has new line set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male \n message} female {female \n message} other {other \n message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male \\n message} female {female \\n message} other {other \\n message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \\n message\',',
            '      female: \'female \\n message\',',
            '      other: \'other \\n message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has single quotation mark set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male \' message} female {female \' message} other {other \' message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male \' message} female {female \' message} other {other \' message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \\\' message\',',
            '      female: \'female \\\' message\',',
            '      other: \'other \\\' message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has dollar sign set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male \$ message} female {female \$ message} other {other \$ message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male \$ message} female {female \$ message} other {other \$ message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \\\$ message\',',
            '      female: \'female \\\$ message\',',
            '      other: \'other \\\$ message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has placeholder which is sticked at the ending with the text for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male {gender}abc} female {female {gender}abc} other {other {gender}abc}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male {gender}abc} female {female {gender}abc} other {other {gender}abc}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \${gender}abc\',',
            '      female: \'female \${gender}abc\',',
            '      other: \'other \${gender}abc\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has placeholder which is sticked at the ending with the underscore sign for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male {gender}_} female {female {gender}_} other {other {gender}_}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male {gender}_} female {female {gender}_} other {other {gender}_}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \${gender}_\',',
            '      female: \'female \${gender}_\',',
            '      other: \'other \${gender}_\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has placeholder which is sticked at the ending with the number for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male {gender}357 .} female {female {gender}357 .} other {other {gender}357 .}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male {gender}357 .} female {female {gender}357 .} other {other {gender}357 .}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male \${gender}357 .\',',
            '      female: \'female \${gender}357 .\',',
            '      other: \'other \${gender}357 .\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has placeholder which is sticked at the beginning and at the ending with the text for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male before{gender}after} female {female before{gender}after} other {other before{gender}after}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male before{gender}after} female {female before{gender}after} other {other before{gender}after}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male before\${gender}after\',',
            '      female: \'female before\${gender}after\',',
            '      other: \'other before\${gender}after\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test gender dart getter when description has new line set', () {
      var label = Label('labelName',
          '{gender, select, male {male message} female {female message} other {other message}}',
          description: 'Description with \n new line');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\n new line\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when description has single quotation mark set',
        () {
      var label = Label('labelName',
          '{gender, select, male {male message} female {female message} other {other message}}',
          description: 'Description with \' single quotation mark');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\' single quotation mark\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test gender dart getter when description has dollar sign set', () {
      var label = Label('labelName',
          '{gender, select, male {male message} female {female message} other {other message}}',
          description: 'Description with \$ dollar sign');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\$ dollar sign\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has placeholder set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male message with {name} placeholder} female {female message with {name} placeholder} other {other message with {name} placeholder}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message with {name} placeholder} female {female message with {name} placeholder} other {other message with {name} placeholder}}`',
            '  String labelName(String gender, Object name) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message with \$name placeholder\',',
            '      female: \'female message with \$name placeholder\',',
            '      other: \'other message with \$name placeholder\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender, name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has two placeholders set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {male message with {firstName} {lastName} placeholders} female {female message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message with {firstName} {lastName} placeholders} female {female message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}`',
            '  String labelName(String gender, Object firstName, Object lastName) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message with \$firstName \$lastName placeholders\',',
            '      female: \'female message with \$firstName \$lastName placeholders\',',
            '      other: \'other message with \$firstName \$lastName placeholders\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender, firstName, lastName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test gender dart getter when content has plural content set for all gender forms',
        () {
      var label = Label('labelName',
          '{gender, select, male {He has {apples, plural, one {one apple} other {{apples} apples}}} female {She has {apples, plural, one {one apple} other {{apples} apples}}} other {Person has {apples, plural, one {one apple} other {{apples} apples}}}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {He has {apples, plural, one {one apple} other {{apples} apples}}} female {She has {apples, plural, one {one apple} other {{apples} apples}}} other {Person has {apples, plural, one {one apple} other {{apples} apples}}}}`',
            '  String labelName(String gender, Object apples) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'He has {apples, plural, one {one apple} other {{apples} apples}}\',',
            '      female: \'She has {apples, plural, one {one apple} other {{apples} apples}}\',',
            '      other: \'Person has {apples, plural, one {one apple} other {{apples} apples}}\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender, apples],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test gender dart getter when content has additional gender form set',
        () {
      var label = Label('labelName',
          '{gender, select, male {male message} unsupportedGenderForm {unsupported gender form message} female {female message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} unsupportedGenderForm {unsupported gender form message} female {female message} other {other message}}`',
            '  String labelName(Object gender) {',
            '    return Intl.select(',
            '      gender,',
            '      {',
            '        \'male\': \'male message\',',
            '        \'unsupportedGenderForm\': \'unsupported gender form message\',',
            '        \'female\': \'female message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test gender dart getter when content has repeated gender form set',
        () {
      var label = Label('labelName',
          '{gender, select, male {male message} male {repeated male message} female {female message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{gender, select, male {male message} male {repeated male message} female {female message} other {other message}}`',
            '  String labelName(String gender) {',
            '    return Intl.gender(',
            '      gender,',
            '      male: \'male message\',',
            '      female: \'female message\',',
            '      other: \'other message\',',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [gender],',
            '    );',
            '  }'
          ].join('\n')));
    });
  });

  group('Select getters', () {
    test('Test select dart getter with name and content set', () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} bar {bar message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test select dart getter with name, content and placeholders set', () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} bar {bar message} other {other message}}',
          placeholders: ['choice']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter with name, content and placeholders set when select cases are empty',
        () {
      var label = Label('labelName', '{choice, select, foo {} bar {} other {}}',
          placeholders: ['choice']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {} bar {} other {}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'\',',
            '        \'bar\': \'\',',
            '        \'other\': \'\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has backtick set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo `message`} bar {bar `message`} other {other `message`}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo \'message\'} bar {bar \'message\'} other {other \'message\'}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo `message`\',',
            '        \'bar\': \'bar `message`\',',
            '        \'other\': \'other `message`\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has new line set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo \n message} bar {bar \n message} other {other \n message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo \\n message} bar {bar \\n message} other {other \\n message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \\n message\',',
            '        \'bar\': \'bar \\n message\',',
            '        \'other\': \'other \\n message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has single quotation mark set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo \' message} bar {bar \' message} other {other \' message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo \' message} bar {bar \' message} other {other \' message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \\\' message\',',
            '        \'bar\': \'bar \\\' message\',',
            '        \'other\': \'other \\\' message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has dollar sign set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo \$ message} bar {bar \$ message} other {other \$ message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo \$ message} bar {bar \$ message} other {other \$ message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \\\$ message\',',
            '        \'bar\': \'bar \\\$ message\',',
            '        \'other\': \'other \\\$ message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder which is sticked at the ending with the text for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo {choice}abc} bar {bar {choice}abc} other {other {choice}abc}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo {choice}abc} bar {bar {choice}abc} other {other {choice}abc}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \${choice}abc\',',
            '        \'bar\': \'bar \${choice}abc\',',
            '        \'other\': \'other \${choice}abc\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder which is sticked at the ending with the underscore sign for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo {choice}_} bar {bar {choice}_} other {other {choice}_}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo {choice}_} bar {bar {choice}_} other {other {choice}_}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \${choice}_\',',
            '        \'bar\': \'bar \${choice}_\',',
            '        \'other\': \'other \${choice}_\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder which is sticked at the ending with the number for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo {choice}357 .} bar {bar {choice}357 .} other {other {choice}357 .}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo {choice}357 .} bar {bar {choice}357 .} other {other {choice}357 .}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo \${choice}357 .\',',
            '        \'bar\': \'bar \${choice}357 .\',',
            '        \'other\': \'other \${choice}357 .\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder which is sticked at the beginning and at the ending with the text for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo before{choice}after} bar {bar before{choice}after} other {other before{choice}after}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo before{choice}after} bar {bar before{choice}after} other {other before{choice}after}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo before\${choice}after\',',
            '        \'bar\': \'bar before\${choice}after\',',
            '        \'other\': \'other before\${choice}after\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test select dart getter when description has new line set', () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} bar {bar message} other {other message}}',
          description: 'Description with \n new line');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'Description with \\n new line\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when description has single quotation mark set',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} bar {bar message} other {other message}}',
          description: 'Description with \' single quotation mark');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\' single quotation mark\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test select dart getter when description has dollar sign set', () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} bar {bar message} other {other message}}',
          description: 'Description with \$ dollar sign');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'Description with \\\$ dollar sign\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message with {name} placeholder} bar {bar message with {name} placeholder} other {other message with {name} placeholder}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message with {name} placeholder} bar {bar message with {name} placeholder} other {other message with {name} placeholder}}`',
            '  String labelName(Object choice, Object name) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message with \$name placeholder\',',
            '        \'bar\': \'bar message with \$name placeholder\',',
            '        \'other\': \'other message with \$name placeholder\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice, name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has placeholder set for all select cases and reverse placeholders order',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message with {name} placeholder} bar {bar message with {name} placeholder} other {other message with {name} placeholder}}',
          placeholders: ['name', 'choice']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message with {name} placeholder} bar {bar message with {name} placeholder} other {other message with {name} placeholder}}`',
            '  String labelName(Object choice, Object name) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message with \$name placeholder\',',
            '        \'bar\': \'bar message with \$name placeholder\',',
            '        \'other\': \'other message with \$name placeholder\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice, name],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has two placeholders set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message with {firstName} {lastName} placeholders} bar {bar message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message with {firstName} {lastName} placeholders} bar {bar message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}`',
            '  String labelName(Object choice, Object firstName, Object lastName) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message with \$firstName \$lastName placeholders\',',
            '        \'bar\': \'bar message with \$firstName \$lastName placeholders\',',
            '        \'other\': \'other message with \$firstName \$lastName placeholders\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice, firstName, lastName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has two placeholders set for all select cases and reverse placeholders order',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message with {firstName} {lastName} placeholders} bar {bar message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}',
          placeholders: ['lastName', 'firstName', 'choice']);

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message with {firstName} {lastName} placeholders} bar {bar message with {firstName} {lastName} placeholders} other {other message with {firstName} {lastName} placeholders}}`',
            '  String labelName(Object choice, Object lastName, Object firstName) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message with \$firstName \$lastName placeholders\',',
            '        \'bar\': \'bar message with \$firstName \$lastName placeholders\',',
            '        \'other\': \'other message with \$firstName \$lastName placeholders\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice, lastName, firstName],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test(
        'Test select dart getter when content has plural content set for all select cases',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo {apples, plural, one {one apple} other {{apples} apples}}} bar {bar {apples, plural, one {one apple} other {{apples} apples}}} other {other {apples, plural, one {one apple} other {{apples} apples}}}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo {apples, plural, one {one apple} other {{apples} apples}}} bar {bar {apples, plural, one {one apple} other {{apples} apples}}} other {other {apples, plural, one {one apple} other {{apples} apples}}}}`',
            '  String labelName(Object choice, Object apples) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo {apples, plural, one {one apple} other {{apples} apples}}\',',
            '        \'bar\': \'bar {apples, plural, one {one apple} other {{apples} apples}}\',',
            '        \'other\': \'other {apples, plural, one {one apple} other {{apples} apples}}\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice, apples],',
            '    );',
            '  }'
          ].join('\n')));
    });

    test('Test select dart getter when content has repeated select case set',
        () {
      var label = Label('labelName',
          '{choice, select, foo {foo message} foo {repeated foo message} bar {bar message} other {other message}}');

      expect(
          label.generateDartGetter(),
          equals([
            '  /// `{choice, select, foo {foo message} foo {repeated foo message} bar {bar message} other {other message}}`',
            '  String labelName(Object choice) {',
            '    return Intl.select(',
            '      choice,',
            '      {',
            '        \'foo\': \'foo message\',',
            '        \'bar\': \'bar message\',',
            '        \'other\': \'other message\',',
            '      },',
            '      name: \'labelName\',',
            '      desc: \'\',',
            '      args: [choice],',
            '    );',
            '  }'
          ].join('\n')));
    });
  });

  group('Label metadata', () {
    test('Test label metadata generator when label name is invalid', () {
      var label = Label('Invalid label name', 'Some content');

      expect(
        label.generateMetadata(),
        equals('    // skipped metadata for the \'Invalid label name\' key'),
      );
    });

    test('Test label metadata generator when label content is empty', () {
      var label = Label('labelName', '');

      expect(
        label.generateMetadata(),
        equals('    \'labelName\': []'),
      );
    });

    test(
        'Test label metadata generator when label content contains empty curly braces pair',
        () {
      var label = Label('labelName', '{}');

      expect(
        label.generateMetadata(),
        equals('    // skipped metadata for the \'labelName\' key'),
      );
    });

    test(
        'Test label metadata generator when label content contains valid placeholder',
        () {
      var label = Label('labelName', '{name}');

      expect(
        label.generateMetadata(),
        equals('    \'labelName\': [\'name\']'),
      );
    });

    test(
        'Test label metadata generator when label content contains few valid placeholders',
        () {
      var label = Label('labelName', 'Hi {firstName} {lastName}!');

      expect(
        label.generateMetadata(),
        equals('    \'labelName\': [\'firstName\', \'lastName\']'),
      );
    });

    test(
        'Test label metadata generator when label content contains invalid placeholder name',
        () {
      var label = Label('labelName', 'Hi {invalie-placeholder}!');

      expect(
        label.generateMetadata(),
        equals('    // skipped metadata for the \'labelName\' key'),
      );
    });

    test(
        'Test label metadata generator when label content contains invalid placeholder declaration',
        () {
      var label = Label('labelName', 'Hi {{year}}!');

      expect(
        label.generateMetadata(),
        equals('    // skipped metadata for the \'labelName\' key'),
      );
    });
  });
}
