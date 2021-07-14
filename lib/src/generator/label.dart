import 'dart:collection';

import '../parser/icu_parser.dart';
import '../parser/message_format.dart';
import '../utils/utils.dart';

final parser = IcuParser();

enum ContentType { literal, argument, plural, gender, select, compound }

class ValidationException implements Exception {
  final String? message;

  ValidationException([this.message]);
}

class ParseException implements Exception {
  final String? message;

  ParseException([this.message]);
}

class Argument {
  Type type;
  String name;

  Argument(this.type, this.name);

  bool isObject() => type == Object;

  bool isString() => type == String;

  bool isNum() => type == num;

  @override
  String toString() => '$type $name';

  @override
  bool operator ==(obj) => obj is Argument && obj.name == name;

  @override
  int get hashCode => name.hashCode;
}

class Label {
  String name;
  String content;
  String? type;
  String? description;
  List<String>? placeholders;

  Label(this.name, this.content,
      {this.type, this.description, this.placeholders});

  /// Generates label getter.
  String generateDartGetter() {
    try {
      var content = _escape(this.content);
      var description = _escape(this.description ?? '');

      var parsedContent = parser.parse(content);
      if (parsedContent == null) {
        throw ParseException();
      }

      var args = _getArgs(placeholders, parsedContent);
      var contentType = _getContentType(parsedContent, args);

      var isValid = _validate(name, content, args);
      if (!isValid) {
        throw ValidationException();
      }

      switch (contentType) {
        case ContentType.literal:
          {
            return [
              _generateDartDoc(),
              '  String get $name {',
              '    return Intl.message(',
              '      \'$content\',',
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.argument:
        case ContentType.compound:
          {
            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              '    return Intl.message(',
              '      \'${_generateCompoundContent(parsedContent)}\',',
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.plural:
          {
            var pluralArg = args.firstWhere((arg) => arg.isNum()).name;

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              '    return Intl.plural(',
              '      ${pluralArg},',
              _generatePluralOptions(parsedContent[0] as PluralElement),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.gender:
          {
            var genderArg = args.firstWhere((arg) => arg.isString()).name;

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              '    return Intl.gender(',
              '      ${genderArg},',
              _generateGenderOptions(parsedContent[0] as GenderElement),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.select:
          {
            var choiceArg = args[0]
                .name; // The first argument in [args] must correspond to the [choice] Object.

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              '    return Intl.select(',
              '      ${choiceArg},',
              _generateSelectOptions(parsedContent[0] as SelectElement),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
      }
    } catch (e) {
      if (!(e is ValidationException)) {
        error("The '${name}' key will be ignored due to parsing errors.");
      }

      return "  // skipped getter for the '${_escape(name)}' key";
    }
  }

  /// Generates label metadata.
  String generateMetadata() {
    try {
      var parsedContent = parser.parse(content);
      if (parsedContent == null) {
        throw ParseException();
      }

      var args = _getArgs(placeholders, parsedContent);

      var isValid = _validate(name, content, args, false);
      if (!isValid) {
        throw ValidationException();
      }

      return "    '${name}': [${args.map((arg) => '\'${arg.name}\'').join(', ')}]";
    } catch (e) {
      if (!(e is ValidationException)) {
        error(
            "The '${name}' key metadata will be ignored due to parsing errors.");
      }

      return "    // skipped metadata for the '${_escape(name)}' key";
    }
  }

  String _generateDartDoc() => '  /// `${_escapeDartDoc(content)}`';

  String _generateDartMethodParameters(List<Argument> args) =>
      args.map((arg) => '$arg').join(', ');

  String _generateDartMethodArgs(List<Argument> args) =>
      args.map((arg) => arg.name).join(', ');

  bool _validate(String name, String content, List<Argument> args,
      [showWarnings = true]) {
    var variableRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    var placeholderRegex = RegExp('\$[a-zA-Z_][a-zA-Z0-9_]*');
    var reservedKeywords = ['current'];

    if (!variableRegex.hasMatch(name)) {
      if (showWarnings) {
        warning(
            "The '${name}' key will be ignored as its name does not follow naming convention.");
      }
      return false;
    }

    if (reservedKeywords.contains(name)) {
      if (showWarnings) {
        warning(
            "The '${name}' key will be ignored as '${name}' is a reserved keyword.");
      }
      return false;
    }

    for (var arg in args) {
      if (!variableRegex.hasMatch(arg.name)) {
        if (showWarnings) {
          warning(
              "The '${name}' key will be ignored as its placeholder '${arg.name}' does not follow naming convention.");
        }
        return false;
      }
    }

    if (placeholderRegex.hasMatch(content) && showWarnings) {
      warning(
          "Did you mean to use placeholders within the '${name}' key? Try wrapping them within curly braces.");
    }

    return true;
  }

  /// Merges meta args with extracted args from the message with preserved order.
  List<Argument> _getArgs(List<String>? placeholders, List<BaseElement> data) {
    var args = placeholders != null
        ? placeholders
            .map((placeholder) => Argument(Object, placeholder))
            .toList()
        : <Argument>[];

    data
        .where((item) => [
              ElementType.argument,
              ElementType.plural,
              ElementType.gender,
              ElementType.select
            ].contains(item.type))
        .forEach((item) {
      switch (item.type) {
        case ElementType.argument:
          {
            _updateArgsData(args, [Argument(Object, item.value)]);
            break;
          }
        case ElementType.plural:
          {
            _updateArgsData(args, [Argument(num, item.value)]);
            _updateArgsData(args, _getPluralOptionsArgs(item as PluralElement));
            break;
          }
        case ElementType.gender:
          {
            _updateArgsData(args, [Argument(String, item.value)]);
            _updateArgsData(args, _getGenderOptionsArgs(item as GenderElement));
            break;
          }
        case ElementType.select:
          {
            var choiceArg = Argument(Object, item.value);
            if (args.isNotEmpty && args.indexOf(choiceArg) != 0) {
              warning(
                  "The '${name}' key contains a select message which requires '${item.value}' placeholder as a first item in 'placeholders' declaration map.");
            }

            _updateArgsData(args, [choiceArg], forceBeginning: true);
            _updateArgsData(args, _getSelectOptionsArgs(item as SelectElement));
            break;
          }
        default:
          {}
      }
    });

    return LinkedHashSet<Argument>.from(args).toList();
  }

  void _updateArgsData(List<Argument> existingArgs, List<Argument> newArgs,
      {bool forceBeginning = false}) {
    newArgs.forEach((newArg) {
      var index = existingArgs.indexOf(newArg);

      if (index != -1) {
        if (existingArgs.elementAt(index).isObject()) {
          existingArgs.elementAt(index).type = newArg.type;
        }

        if (forceBeginning && index > 0) {
          var arg = existingArgs.removeAt(index);
          existingArgs.insert(0, arg);
        }
      } else {
        if (forceBeginning) {
          existingArgs.insert(0, newArg);
        } else {
          existingArgs.add(newArg);
        }
      }
    });
  }

  List<Argument> _getPluralOptionsArgs(PluralElement pluralElement) {
    var args = <Argument>[];

    pluralElement.options
        .where((option) => [
              '=0',
              'zero',
              '=1',
              'one',
              '=2',
              'two',
              'few',
              'many',
              'other'
            ].contains(option.name))
        .forEach((option) =>
            args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<Argument>.from(args).toList();
  }

  List<Argument> _getGenderOptionsArgs(GenderElement genderElement) {
    var args = <Argument>[];

    genderElement.options
        .where((option) => ['female', 'male', 'other'].contains(option.name))
        .forEach((option) =>
            args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<Argument>.from(args).toList();
  }

  List<Argument> _getSelectOptionsArgs(SelectElement selectElement) {
    var args = <Argument>[];

    selectElement.options.forEach((option) =>
        args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<Argument>.from(args).toList();
  }

  List<Argument> _getArgumentOrPluralOrSelectArgs(List<BaseElement> data) {
    var args = <Argument>[];

    data
        .where((item) => [
              ElementType.argument,
              ElementType.plural,
              ElementType.gender,
              ElementType.select
            ].contains(item.type))
        .forEach((item) {
      args.add(Argument(Object, item.value));
    });

    return args;
  }

  ContentType _getContentType(List<BaseElement> data, List<Argument> args) {
    if (_isLiteral(data) && args.isEmpty) {
      return ContentType.literal;
    } else if (_isArgument(data) && args.isNotEmpty) {
      return ContentType.argument;
    } else if (_isPlural(data) && args.isNotEmpty) {
      return ContentType.plural;
    } else if (_isGender(data) && args.isNotEmpty) {
      return ContentType.gender;
    } else if (_isSelect(data) && args.isNotEmpty) {
      return ContentType.select;
    } else {
      return ContentType.compound;
    }
  }

  bool _isLiteral(List<BaseElement> data) => (data.isNotEmpty &&
      data
          .map((BaseElement item) => item.type == ElementType.literal)
          .reduce((bool acc, bool curr) => acc && curr));

  bool _isArgument(List<BaseElement> data) => (data.isNotEmpty &&
      data
          .map((item) =>
              [ElementType.argument, ElementType.literal].contains(item.type))
          .reduce((bool acc, bool curr) => acc && curr));

  bool _isPlural(List<BaseElement> data) =>
      (data.length == 1 && data[0].type == ElementType.plural);

  bool _isGender(List<BaseElement> data) =>
      (data.length == 1 && data[0].type == ElementType.gender);

  bool _isSelect(List<BaseElement> data) =>
      (data.length == 1 && data[0].type == ElementType.select);

  String _generateCompoundContent(List<BaseElement> data) {
    var content = data
        .asMap()
        .map((index, item) {
          switch (item.type) {
            case ElementType.literal:
              {
                return MapEntry(index, item.value);
              }
            case ElementType.argument:
              {
                return MapEntry(
                    index,
                    _isArgumentBracingRequired(data, index)
                        ? '\${${item.value}}'
                        : '\$${item.value}');
              }
            case ElementType.plural:
              {
                return MapEntry(index,
                    '\${${_generatePluralMessage(item as PluralElement)}}');
              }
            case ElementType.gender:
              {
                return MapEntry(index,
                    '\${${_generateGenderMessage(item as GenderElement)}}');
              }
            case ElementType.select:
              {
                return MapEntry(index,
                    '\${${_generateSelectMessage(item as SelectElement)}}');
              }
            default:
              {
                return MapEntry(index, '');
              }
          }
        })
        .values
        .join();

    return content;
  }

  /// Checks if argument bracing is required.
  ///
  /// Arguments that are immediately followed by alphanumeric character or underscore should be wrapped within curly-braces.
  bool _isArgumentBracingRequired(List<BaseElement> data, int index) {
    return data.length > 1 &&
        index < (data.length - 1) &&
        data[index + 1].type == ElementType.literal &&
        data[index + 1].value.startsWith(RegExp('[a-zA-Z0-9_]'));
  }

  String _generatePluralOptions(PluralElement element) {
    var options = <String>[];

    _sanitizePluralOptions(element.options).forEach((option) {
      switch (option.name) {
        case '=0':
        case 'zero':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      zero: '${message}',");
            break;
          }
        case '=1':
        case 'one':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      one: '${message}',");
            break;
          }
        case '=2':
        case 'two':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      two: '${message}',");
            break;
          }
        case 'few':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      few: '${message}',");
            break;
          }
        case 'many':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      many: '${message}',");
            break;
          }
        case 'other':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      other: '${message}',");
            break;
          }
      }
    });

    return options.join('\n');
  }

  /// Removes duplicates and print warnings in case of irregularity for plural options.
  List<Option> _sanitizePluralOptions(List<Option> options) {
    var keys = options.map((option) => option.name);
    var uniqueKeys = LinkedHashSet<String>.from(keys);
    if (uniqueKeys.contains('zero') && uniqueKeys.contains('=0')) {
      uniqueKeys.remove('=0');
    }
    if (uniqueKeys.contains('one') && uniqueKeys.contains('=1')) {
      uniqueKeys.remove('=1');
    }
    if (uniqueKeys.contains('two') && uniqueKeys.contains('=2')) {
      uniqueKeys.remove('=2');
    }

    var sanitized = uniqueKeys
        .map((uniqueKey) =>
            options.firstWhere((option) => option.name == uniqueKey))
        .toList();
    if (sanitized.length != options.length) {
      warning("Detected plural irregularity for the '${name}' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '${name}' key lacks mandatory plural form 'other'.");
    }

    sanitized.forEach((option) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '${name}' key lacks translation for the plural form '${option.name}'.");
      }
    });

    return sanitized;
  }

  String _generateGenderOptions(GenderElement element) {
    var options = <String>[];

    _sanitizeGenderOptions(element.options).forEach((option) {
      switch (option.name) {
        case 'male':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      male: '${message}',");
            break;
          }
        case 'female':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      female: '${message}',");
            break;
          }
        case 'other':
          {
            var message = _generatePluralOrSelectOptionMessage(option);
            options.add("      other: '${message}',");
            break;
          }
        default:
          {}
      }
    });

    return options.join('\n');
  }

  /// Removes duplicates and print warnings in case of irregularity for gender options.
  List<Option> _sanitizeGenderOptions(List<Option> options) {
    var keys = options.map((option) => option.name);
    var uniqueKeys = LinkedHashSet<String>.from(keys);

    var sanitized = uniqueKeys
        .map((uniqueKey) =>
            options.firstWhere((option) => option.name == uniqueKey))
        .toList();
    if (sanitized.length != options.length) {
      warning("Detected gender irregularity for the '${name}' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '${name}' key lacks mandatory gender form 'other'.");
    }

    sanitized.forEach((option) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '${name}' key lacks translation for the gender form '${option.name}'.");
      }
    });

    return sanitized;
  }

  String _generateSelectOptions(SelectElement element) {
    var options = <String>[];

    options.add('      {');
    _sanitizeSelectOptions(element.options).forEach((option) {
      options.add(
          "        '${option.name}': '${_generatePluralOrSelectOptionMessage(option)}',");
    });
    options.add('      },');

    return options.join('\n');
  }

  /// Removes duplicates and print warnings in case of irregularity for select options.
  List<Option> _sanitizeSelectOptions(List<Option> options) {
    var keys = options.map((option) => option.name);
    var uniqueKeys = LinkedHashSet<String>.from(keys);

    var sanitized = uniqueKeys
        .map((uniqueKey) =>
            options.firstWhere((option) => option.name == uniqueKey))
        .toList();
    if (sanitized.length != options.length) {
      warning("Detected select irregularity for the '${name}' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '${name}' key lacks mandatory select case 'other'.");
    }

    sanitized.forEach((option) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '${name}' key lacks translation for the select case '${option.name}'.");
      }
    });

    return sanitized;
  }

  String _generatePluralMessage(PluralElement element) {
    var options = <String>[];

    _sanitizePluralOptions(element.options).forEach((option) {
      var message = _generatePluralOrSelectOptionMessage(option);

      switch (option.name) {
        case '=0':
        case 'zero':
          {
            options.add("zero: '${message}'");
            break;
          }
        case '=1':
        case 'one':
          {
            options.add("one: '${message}'");
            break;
          }
        case '=2':
        case 'two':
          {
            options.add("two: '${message}'");
            break;
          }
        case 'few':
          {
            options.add("few: '${message}'");
            break;
          }
        case 'many':
          {
            options.add("many: '${message}'");
            break;
          }
        case 'other':
          {
            options.add("other: '${message}'");
            break;
          }
      }
    });

    return 'Intl.plural(${element.value}, ${options.join(', ')})';
  }

  String _generateGenderMessage(GenderElement element) {
    var options = <String>[];

    _sanitizeGenderOptions(element.options).forEach((option) {
      var message = _generatePluralOrSelectOptionMessage(option);
      switch (option.name) {
        case 'male':
          {
            options.add("male: '${message}'");
            break;
          }
        case 'female':
          {
            options.add("female: '${message}'");
            break;
          }
        case 'other':
          {
            options.add("other: '${message}'");
            break;
          }
        default:
          {}
      }
    });

    return 'Intl.gender(${element.value}, ${options.join(', ')})';
  }

  String _generateSelectMessage(SelectElement element) {
    var options = <String>[];

    _sanitizeSelectOptions(element.options).forEach((option) {
      options.add(
          "'${option.name}': '${_generatePluralOrSelectOptionMessage(option)}'");
    });

    return 'Intl.select(${element.value}, {${options.join(', ')}})';
  }

  String _generatePluralOrSelectOptionMessage(option) {
    var data = option.value;
    var isValid = _validatePluralOrSelectOption(data);

    return isValid
        ? data
            .asMap()
            .map((index, item) {
              switch (item.type) {
                case ElementType.literal:
                  {
                    return MapEntry(index, item.value);
                  }
                case ElementType.argument:
                  {
                    return MapEntry(
                        index,
                        _isArgumentBracingRequired(data, index)
                            ? '\${${item.value}}'
                            : '\$${item.value}');
                  }
                default:
                  {
                    return MapEntry(index, '');
                  }
              }
            })
            .values
            .join()
        : _getRawPluralOrSelectOption(option);
  }

  /// Validates plural, gender and select options.
  ///
  /// Note: Current implementation only supports trivial plural, gender and select options (literal and argument messages)
  bool _validatePluralOrSelectOption(List<BaseElement> data) => data
      .map((item) =>
          [ElementType.literal, ElementType.argument].contains(item.type))
      .reduce((acc, curr) => acc && curr);

  String _getRawPluralOrSelectOption(Option option) {
    var content = _escape(this.content);

    var startIndex = _findOptionStartIndex(content, option);
    var endIndex = _findOptionEndIndex(content, startIndex);

    return content.substring(startIndex, endIndex);
  }

  int _findOptionStartIndex(String content, Option option) {
    var counter = 0;
    for (var i = 0; i < content.length; i++) {
      var char = content[i];
      switch (char) {
        case '{':
          {
            counter++;
            break;
          }
        case '}':
          {
            counter--;
            break;
          }
      }

      if (counter == 2) {
        var chunk = content.substring(0, i + 1);

        var optionIndex = chunk.lastIndexOf(RegExp('${option.name}(\\s)*{'));
        if (optionIndex != -1 &&
            chunk.substring(optionIndex, i).trim() == option.name) {
          return i + 1;
        }
      }
    }

    return -1;
  }

  int _findOptionEndIndex(String content, int startIndex) {
    var substring = content.substring(startIndex);

    var counter = 1; // option starts with '{'
    for (var i = 0; i < substring.length; i++) {
      var char = substring[i];
      switch (char) {
        case '{':
          {
            counter++;
            break;
          }
        case '}':
          {
            counter--;
            break;
          }
      }

      if (counter == 0) {
        return startIndex + i;
      }
    }

    return -1;
  }

  String _escape(String value) {
    return value
        .replaceAll('\\', '\\\\')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t')
        .replaceAll('\b', '\\b')
        .replaceAll('\f', '\\f')
        .replaceAll('\'', '\\\'')
        .replaceAll('\$', '\\\$');
  }

  String _escapeDartDoc(String value) {
    return value
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t')
        .replaceAll('\b', '\\b')
        .replaceAll('\f', '\\f')
        .replaceAll('`', '\'');
  }
}
