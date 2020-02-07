import 'dart:collection';

import 'package:intl_utils/src/parser.dart';
import 'package:intl_utils/src/message_format.dart';
import 'package:intl_utils/src/utils.dart';

final parser = Parser();

enum ContentType { literal, argument, plural, gender, unsupported }

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message]);
}

class Label {
  String name;
  String content;
  String type;
  String description;
  List<String> placeholders;

  Label(this.name, this.content, {this.type, this.description, this.placeholders});

  String generateDartGetter() {
    try {
      var content = _escape(this.content);
      var description = _escape(this.description ?? '');

      var parsedContent = parser.parse(content);
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
          {
            return [
              '  String $name(${args.map((arg) => 'dynamic $arg').join(', ')}) {',
              '    return Intl.message(',
              '      \'${_generateArgumentContent(parsedContent)}\',',
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${args.join(', ')}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.plural:
          {
            return [
              '  String $name(${args.map((arg) => 'dynamic $arg').join(', ')}) {',
              '    return Intl.plural(',
              '      ${args[0]},',
              _generatePluralOptions(parsedContent[0]),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${args.join(', ')}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.gender:
          {
            return [
              '  String $name(${args.map((arg) => 'dynamic $arg').join(', ')}) {',
              '    return Intl.gender(',
              '      ${args[0]},',
              _generateGenderOptions(parsedContent[0]),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${args.join(', ')}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.unsupported:
        default:
          {
            warning("The '${name}' key has an unsupported content type.");

            return [
              '  String ${args.isNotEmpty ? '${name}(${args.map((arg) => 'dynamic $arg').join(', ')})' : 'get ${name}'} {',
              '    return Intl.message(',
              '      \'${content}\',',
              '      name: \'${name}\',',
              '      desc: \'${description}\',',
              '      args: [${args.join(', ')}],',
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

  bool _validate(String name, String content, List<String> args) {
    var variableRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    var placeholderRegex = RegExp('\$[a-zA-Z_][a-zA-Z0-9_]*');

    if (!variableRegex.hasMatch(name)) {
      warning("The '${name}' key will be ignored as its name does not follow naming convention.");
      return false;
    }

    for (var arg in args) {
      if (!variableRegex.hasMatch(arg)) {
        warning("The '${name}' key will be ignored as its placeholder '${arg}' does not follow naming convention.");
        return false;
      }
    }

    if (placeholderRegex.hasMatch(content)) {
      warning("Did you mean to use placeholders within the '${name}' key? Try wrapping them within curly braces.");
    }

    return true;
  }

  /// union of meta args and extracted args from the message with preserved order
  List<String> _getArgs(List<String> placeholders, List<BaseElement> data) {
    var metaArgs = placeholders ?? <String>[];
    var extractedArgs = <String>[];

    data.where((item) => [Type.argument, Type.plural, Type.gender, Type.select].contains(item.type)).forEach((item) {
      extractedArgs.add(item.value);

      switch (item.type) {
        case Type.plural:
          {
            extractedArgs.addAll(_getPluralOptionsArgs(item));
            break;
          }
        case Type.gender:
          {
            extractedArgs.addAll(_getGenderOptionsArgs(item));
            break;
          }
        case Type.select:
          {
            extractedArgs.addAll(_getSelectOptionsArgs(item));
            break;
          }
        default:
          {}
      }
    });

    var args = <String>[...metaArgs, ...extractedArgs];

    return LinkedHashSet<String>.from(args).toList();
  }

  List<String> _getPluralOptionsArgs(PluralElement pluralElement) {
    var args = <String>[];

    pluralElement.options
        .where((option) => ['=0', 'zero', '=1', 'one', '=2', 'two', 'few', 'many', 'other'].contains(option.name))
        .forEach((option) => args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<String>.from(args).toList();
  }

  List<String> _getGenderOptionsArgs(GenderElement genderElement) {
    var args = <String>[];

    genderElement.options
        .where((option) => ['female', 'male', 'other'].contains(option.name))
        .forEach((option) => args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<String>.from(args).toList();
  }

  List<String> _getSelectOptionsArgs(SelectElement selectElement) {
    var args = <String>[];

    selectElement.options.forEach((option) => args.addAll(_getArgumentOrPluralOrSelectArgs(option.value)));

    return LinkedHashSet<String>.from(args).toList();
  }

  List<String> _getArgumentOrPluralOrSelectArgs(List<BaseElement> data) {
    var args = <String>[];

    data.where((item) => [Type.argument, Type.plural, Type.gender, Type.select].contains(item.type)).forEach((item) {
      args.add(item.value);
    });

    return args;
  }

  ContentType _getContentType(List<BaseElement> data, List<String> args) {
    if (_isLiteral(data) && args.isEmpty) {
      return ContentType.literal;
    } else if (_isArgument(data) && args.isNotEmpty) {
      return ContentType.argument;
    } else if (_isPlural(data) && args.isNotEmpty) {
      return ContentType.plural;
    } else if (_isGender(data) && args.isNotEmpty) {
      return ContentType.gender;
    } else {
      return ContentType.unsupported; // other types which are not supported yet
    }
  }

  bool _isLiteral(List<BaseElement> data) {
    return (data.isNotEmpty &&
        data.map((BaseElement item) => item.type == Type.literal).reduce((bool acc, bool curr) => acc && curr));
  }

  bool _isArgument(List<BaseElement> data) {
    return (data.isNotEmpty &&
        data
            .map((item) => [Type.argument, Type.literal].contains(item.type))
            .reduce((bool acc, bool curr) => acc && curr));
  }

  bool _isPlural(List<BaseElement> data) {
    return (data.isNotEmpty &&
        data.map((item) => item.type == Type.plural).reduce((bool acc, bool curr) => acc && curr));
  }

  bool _isGender(List<BaseElement> data) {
    return (data.isNotEmpty &&
        data.map((item) => item.type == Type.gender).reduce((bool acc, bool curr) => acc && curr));
  }

  String _generateArgumentContent(List<BaseElement> data) {
    var content = data
        .asMap()
        .map((index, item) {
          switch (item.type) {
            case Type.literal:
              {
                return MapEntry(index, item.value);
              }
            case Type.argument:
              {
                return MapEntry(
                    index, _isArgumentBracingRequired(data, index) ? '\${${item.value}}' : '\$${item.value}');
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

  /// Arguments that are immediately followed by alphanumeric character or underscore should be wrapped within curly-braces.
  bool _isArgumentBracingRequired(List<BaseElement> data, int index) {
    return data.length > 1 &&
        index < (data.length - 1) &&
        data[index + 1].type == Type.literal &&
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

  /// remove duplicates and print warnings in case of irregularity
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

    var sanitized = uniqueKeys.map((uniqueKey) => options.firstWhere((option) => option.name == uniqueKey)).toList();
    if (sanitized.length != options.length) {
      warning("Detected plural irregularity for the '${name}' key.");
    }

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

  /// remove duplicates and print warnings in case of irregularity
  List<Option> _sanitizeGenderOptions(List<Option> options) {
    var keys = options.map((option) => option.name);
    var uniqueKeys = LinkedHashSet<String>.from(keys);

    var sanitized = uniqueKeys.map((uniqueKey) => options.firstWhere((option) => option.name == uniqueKey)).toList();
    if (sanitized.length != options.length) {
      warning("Detected gender irregularity for the '${name}' key.");
    }

    return sanitized;
  }

  String _generatePluralOrSelectOptionMessage(option) {
    var data = option.value;
    var isValid = _validatePluralOrSelectOption(data);

    return isValid
        ? data
            .asMap()
            .map((index, item) {
              switch (item.type) {
                case Type.literal:
                  {
                    return MapEntry(index, item.value);
                  }
                case Type.argument:
                  {
                    return MapEntry(
                        index, _isArgumentBracingRequired(data, index) ? '\${${item.value}}' : '\$${item.value}');
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

  /// current implementation only supports trivial plural and gender options (literal and argument messages)
  bool _validatePluralOrSelectOption(List<BaseElement> data) {
    return data.map((item) => [Type.literal, Type.argument].contains(item.type)).reduce((acc, curr) => acc && curr);
  }

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
        if (optionIndex != -1 && chunk.substring(optionIndex, i).trim() == option.name) {
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
        .replaceAll(RegExp('\r'), '\\r')
        .replaceAll(RegExp('\n'), '\\n')
        .replaceAll(RegExp('\''), '\\\'')
        .replaceAll(RegExp('\\\$'), '\\\$');
  }
}
