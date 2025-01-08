// This file incorporates work covered by the following copyright and
// permission notice:
//
//     Copyright 2014 The Flutter Authors. All rights reserved.
//
//     Redistribution and use in source and binary forms, with or without modification,
//     are permitted provided that the following conditions are met:
//
//         * Redistributions of source code must retain the above copyright
//         notice, this list of conditions and the following disclaimer.
//         * Redistributions in binary form must reproduce the above
//         copyright notice, this list of conditions and the following
//         disclaimer in the documentation and/or other materials provided
//         with the distribution.
//         * Neither the name of Google Inc. nor the names of its
//         contributors may be used to endorse or promote products derived
//         from this software without specific prior written permission.
//
//     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//     ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//     WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//     ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//     (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//     LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//     SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//     Copyright 2014 The Flutter Authors. All rights reserved.
//     Use of this source code is governed by a BSD-style license that can be
//     found in the LICENSE file.

import 'dart:collection';

import '../parser/icu_parser.dart';
import '../parser/message_format.dart';
import '../utils/utils.dart';

final parser = IcuParser();

enum ContentType { literal, argument, plural, gender, select, compound }

class ValidationException implements Exception {
  final String? message;

  ValidationException([this.message]);

  @override
  String toString() => message ?? 'ValidationException';
}

class ParseException implements Exception {
  final String? message;

  ParseException([this.message]);

  @override
  String toString() => message ?? 'ParseException';
}

class PlaceholderException implements Exception {
  final String message;

  PlaceholderException(this.message);

  @override
  String toString() => message;
}

class Argument {
  String type;

  String name;

  ElementType? elementType;

  Placeholder? placeholderRef;

  Argument(this.type, this.name, this.elementType);

  Argument.fromPlaceholder(Placeholder placeholder)
      : type = placeholder.type ?? 'Object',
        name = placeholder.name,
        placeholderRef = placeholder;

  bool isObject() => type == 'Object';

  bool isObjectSpecified() => placeholderRef?.type == 'Object';

  bool isString() => type == 'String';

  bool isNum() => type == 'num';

  bool isPluralArg() => elementType == ElementType.plural;

  bool isGenderArg() => elementType == ElementType.gender;

  bool isSelectArg() => elementType == ElementType.select;

  bool isFormatDefined() => placeholderRef?.requiresFormatting == true;

  bool isFormatAllowed() =>
      (placeholderRef?.requiresFormatting == true) &&
      ![ElementType.plural, ElementType.gender, ElementType.select]
          .contains(elementType);

  String get formattedName => isFormatAllowed() ? '${name}String' : name;

  @override
  String toString() => '$type $name';

  @override
  bool operator ==(Object other) => other is Argument && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

const Set<String> _validDateFormats = <String>{
  'd',
  'E',
  'EEEE',
  'LLL',
  'LLLL',
  'M',
  'Md',
  'MEd',
  'MMM',
  'MMMd',
  'MMMEd',
  'MMMM',
  'MMMMd',
  'MMMMEEEEd',
  'QQQ',
  'QQQQ',
  'y',
  'yM',
  'yMd',
  'yMEd',
  'yMMM',
  'yMMMd',
  'yMMMEd',
  'yMMMM',
  'yMMMMd',
  'yMMMMEEEEd',
  'yQQQ',
  'yQQQQ',
  'H',
  'Hm',
  'Hms',
  'j',
  'jm',
  'jms',
  'jmv',
  'jmz',
  'jv',
  'jz',
  'm',
  'ms',
  's',
};

const Set<String> _validNumberFormats = <String>{
  'compact',
  'compactCurrency',
  'compactSimpleCurrency',
  'compactLong',
  'currency',
  'decimalPattern',
  'decimalPercentPattern',
  'percentPattern',
  'scientificPattern',
  'simpleCurrency',
};

const Set<String> _numberFormatsWithNamedParameters = <String>{
  'compact',
  'compactCurrency',
  'compactSimpleCurrency',
  'compactLong',
  'currency',
  'decimalPercentPattern',
  'simpleCurrency',
};

class OptionalParameter {
  const OptionalParameter(this.name, this.value);

  final String name;
  final Object value;
}

class Placeholder {
  Placeholder(this.resourceId, this.name, Map<String, Object?> attributes)
      : example = _stringAttribute(resourceId, name, attributes, 'example'),
        type = _stringAttribute(resourceId, name, attributes, 'type'),
        format = _stringAttribute(resourceId, name, attributes, 'format'),
        optionalParameters = _optionalParameters(resourceId, name, attributes),
        isCustomDateFormat =
            _boolAttribute(resourceId, name, attributes, 'isCustomDateFormat');

  final String resourceId;
  final String name;
  final String? example;
  final String? type;
  final String? format;
  final List<OptionalParameter> optionalParameters;
  final bool? isCustomDateFormat;

  bool get requiresFormatting =>
      <String>['DateTime', 'double', 'num', 'int'].contains(type) &&
      format != null;
  bool get isNumber => <String>['double', 'int', 'num'].contains(type);
  bool get hasValidNumberFormat => _validNumberFormats.contains(format);
  bool get hasNumberFormatWithParameters =>
      _numberFormatsWithNamedParameters.contains(format);
  bool get isDate => 'DateTime' == type;
  bool get hasValidDateFormat => _validDateFormats.contains(format);

  static String? _stringAttribute(
    String resourceId,
    String name,
    Map<String, Object?> attributes,
    String attributeName,
  ) {
    final Object? value = attributes[attributeName];
    if (value == null) {
      return null;
    }
    if (value is! String || value.isEmpty) {
      throw PlaceholderException(
          "The '$attributeName' value of the '$name' placeholder in message '$resourceId' must be a non-empty string.");
    }
    return value;
  }

  static bool? _boolAttribute(
    String resourceId,
    String name,
    Map<String, Object?> attributes,
    String attributeName,
  ) {
    final Object? value = attributes[attributeName];
    if (value == null) {
      return null;
    }
    if (value != 'true' && value != 'false') {
      throw PlaceholderException(
        "The '$attributeName' value of the '$name' placeholder in message '$resourceId' must be a string representation of a boolean value ('true', 'false').",
      );
    }
    return value == 'true';
  }

  static List<OptionalParameter> _optionalParameters(
      String resourceId, String name, Map<String, Object?> attributes) {
    final Object? value = attributes['optionalParameters'];
    if (value == null) {
      return <OptionalParameter>[];
    }

    if (value is! Map<String, dynamic>) {
      throw PlaceholderException(
          "The 'optionalParameters' value of the '$name' placeholder in message '$resourceId' is not a properly formatted Map. "
          "Ensure that it is a map with keys that are strings.");
    }
    final Map<String, Object> optionalParameterMap =
        Map<String, Object>.from(value);
    return optionalParameterMap.keys
        .map<OptionalParameter>((String parameterName) => OptionalParameter(
            parameterName, optionalParameterMap[parameterName]!))
        .toList();
  }
}

class Label {
  String name;
  String content;
  String? type;
  String? description;
  List<Placeholder>? placeholders;

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
              ..._generateFormattingLogic(args),
              '    return Intl.message(',
              '      \'${_generateCompoundContent(parsedContent, args)}\',',
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.plural:
          {
            var pluralArg = args.firstWhere((arg) => arg.isPluralArg()).name;

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              ..._generateFormattingLogic(args),
              '    return Intl.plural(',
              '      $pluralArg,',
              _generatePluralOptions(parsedContent[0] as PluralElement, args),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.gender:
          {
            var genderArg = args.firstWhere((arg) => arg.isGenderArg()).name;

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              ..._generateFormattingLogic(args),
              '    return Intl.gender(',
              '      $genderArg,',
              _generateGenderOptions(parsedContent[0] as GenderElement, args),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
        case ContentType.select:
          {
            var choiceArg = args
                .firstWhere((arg) => arg.isSelectArg())
                .name; // Note: The first argument in [args] must correspond to the [choice] Object.

            return [
              _generateDartDoc(),
              '  String $name(${_generateDartMethodParameters(args)}) {',
              ..._generateFormattingLogic(args),
              '    return Intl.select(',
              '      $choiceArg,',
              _generateSelectOptions(parsedContent[0] as SelectElement, args),
              '      name: \'$name\',',
              '      desc: \'$description\',',
              '      args: [${_generateDartMethodArgs(args)}],',
              '    );',
              '  }'
            ].join('\n');
          }
      }
    } catch (e) {
      if (e is PlaceholderException) {
        error(e.message);
      } else if (e is! ValidationException) {
        error("The '$name' key will be ignored due to parsing errors.");
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

      return "    '$name': [${args.map((arg) => '\'${arg.name}\'').join(', ')}]";
    } catch (e) {
      if (e is! ValidationException) {
        error(
            "The '$name' key metadata will be ignored due to parsing errors.");
      }

      return "    // skipped metadata for the '${_escape(name)}' key";
    }
  }

  String _generateDartDoc() => '  /// `${_escapeDartDoc(content)}`';

  String _generateDartMethodParameters(List<Argument> args) =>
      args.map((arg) => '$arg').join(', ');

  String _generateDartMethodArgs(List<Argument> args) =>
      args.map((arg) => arg.formattedName).join(', ');

  List<String> _generateFormattingLogic(List<Argument> args) {
    return args
        .where((arg) => arg.isFormatAllowed())
        .map((arg) {
          var placeholder = arg.placeholderRef!;

          if (placeholder.isDate) {
            final bool? isCustomDateFormat = placeholder.isCustomDateFormat;

            if (!placeholder.hasValidDateFormat &&
                (isCustomDateFormat == null || !isCustomDateFormat)) {
              throw PlaceholderException(
                  "The '${placeholder.resourceId}' key requires '${placeholder.format}' date format "
                  "for the '${placeholder.name}' placeholder that does not have a corresponding DateFormat constructor.\n"
                  "Check the intl library's DateFormat class constructors for allowed date formats, or set 'isCustomDateFormat' attribute to 'true'.");
            }

            if (placeholder.hasValidDateFormat) {
              return [
                '    final DateFormat ${placeholder.name}DateFormat = DateFormat.${placeholder.format}(Intl.getCurrentLocale());',
                '    final String ${placeholder.name}String = ${placeholder.name}DateFormat.format(${placeholder.name});',
                ''
              ].join('\n');
            }

            return [
              '    final DateFormat ${placeholder.name}DateFormat = DateFormat(\'${_escape(placeholder.format!)}\', Intl.getCurrentLocale());',
              '    final String ${placeholder.name}String = ${placeholder.name}DateFormat.format(${placeholder.name});',
              ''
            ].join('\n');
          } else if (placeholder.isNumber) {
            if (!placeholder.hasValidNumberFormat) {
              throw PlaceholderException(
                  "The '${placeholder.resourceId}' key requires '${placeholder.format}' number format "
                  "for the '${placeholder.name}' placeholder that does not have a corresponding NumberFormat constructor.\n"
                  "Check the intl library's NumberFormat class constructors for allowed number formats.");
            }

            final Iterable<String> parameters =
                placeholder.optionalParameters.map<String>(
              (OptionalParameter parameter) {
                if (parameter.value is num) {
                  return '${parameter.name}: ${parameter.value}';
                } else {
                  return '${parameter.name}: \'${_escape(parameter.value.toString())}\'';
                }
              },
            );

            if (placeholder.hasNumberFormatWithParameters) {
              return [
                '    final NumberFormat ${placeholder.name}NumberFormat = NumberFormat.${placeholder.format}(',
                '      locale: Intl.getCurrentLocale(),',
                '      ${parameters.join(',\n      ')}',
                '    );',
                '    final String ${placeholder.name}String = ${placeholder.name}NumberFormat.format(${placeholder.name});',
                ''
              ].join('\n');
            } else {
              return [
                '    final NumberFormat ${placeholder.name}NumberFormat = NumberFormat.${placeholder.format}(Intl.getCurrentLocale());',
                '    final String ${placeholder.name}String = ${placeholder.name}NumberFormat.format(${placeholder.name});',
                ''
              ].join('\n');
            }
          }
        })
        .whereType<String>()
        .toList();
  }

  bool _validate(String name, String content, List<Argument> args,
      [showWarnings = true]) {
    var variableRegex = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    var placeholderRegex = RegExp('\$[a-zA-Z_][a-zA-Z0-9_]*');
    var reservedKeywords = ['current'];

    if (!variableRegex.hasMatch(name)) {
      if (showWarnings) {
        warning(
            "The '$name' key will be ignored as its name does not follow naming convention.");
      }
      return false;
    }

    if (reservedKeywords.contains(name)) {
      if (showWarnings) {
        warning(
            "The '$name' key will be ignored as '$name' is a reserved keyword.");
      }
      return false;
    }

    for (var arg in args) {
      if (!variableRegex.hasMatch(arg.name)) {
        if (showWarnings) {
          warning(
              "The '$name' key will be ignored as its placeholder '${arg.name}' does not follow naming convention.");
        }
        return false;
      }

      if (arg.isFormatDefined() && !arg.isFormatAllowed()) {
        if (showWarnings) {
          warning(
              "The '$name' key has a defined format for the '${arg.name}' placeholder that will be ignored.\n"
              "Consider using an additional placeholder for formatting purposes.");
        }
      }
    }

    if (placeholderRegex.hasMatch(content) && showWarnings) {
      warning(
          "Did you mean to use placeholders within the '$name' key? Try wrapping them within curly braces.");
    }

    return true;
  }

  /// Merges meta args with extracted args from the message with preserved order.
  List<Argument> _getArgs(
      List<Placeholder>? placeholders, List<BaseElement> data) {
    var args = placeholders != null
        ? placeholders
            .map((placeholder) => Argument.fromPlaceholder(placeholder))
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
            _updateArgsData(args, [Argument('Object', item.value, item.type)]);
            break;
          }
        case ElementType.plural:
          {
            _updateArgsData(args, [Argument('num', item.value, item.type)]);
            _updateArgsData(args, _getPluralOptionsArgs(item as PluralElement));
            break;
          }
        case ElementType.gender:
          {
            _updateArgsData(args, [Argument('String', item.value, item.type)]);
            _updateArgsData(args, _getGenderOptionsArgs(item as GenderElement));
            break;
          }
        case ElementType.select:
          {
            var choiceArg = Argument('Object', item.value, item.type);
            if (args.isNotEmpty && args.indexOf(choiceArg) != 0) {
              warning(
                  "The '$name' key contains a select message which requires '${item.value}' placeholder as a first item in 'placeholders' declaration map.");
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
    for (var newArg in newArgs) {
      var index = existingArgs.indexOf(newArg);

      if (index != -1) {
        var existingArg = existingArgs.elementAt(index);

        if (existingArg.elementType == null && newArg.elementType != null) {
          existingArg.elementType = newArg.elementType;
        }

        if (existingArg.isObject() && !existingArg.isObjectSpecified()) {
          existingArg.type = newArg.type;
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
    }
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

    for (var option in selectElement.options) {
      args.addAll(_getArgumentOrPluralOrSelectArgs(option.value));
    }

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
      args.add(Argument('Object', item.value, null));
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

  String _generateCompoundContent(List<BaseElement> data, List<Argument> args) {
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
                var formattedArg = args
                    .singleWhere((element) => element.name == item.value)
                    .formattedName;

                return MapEntry(
                    index,
                    _isArgumentBracingRequired(data, index)
                        ? '\${$formattedArg}'
                        : '\$$formattedArg');
              }
            case ElementType.plural:
              {
                return MapEntry(index,
                    '\${${_generatePluralMessage(item as PluralElement, args)}}');
              }
            case ElementType.gender:
              {
                return MapEntry(index,
                    '\${${_generateGenderMessage(item as GenderElement, args)}}');
              }
            case ElementType.select:
              {
                return MapEntry(index,
                    '\${${_generateSelectMessage(item as SelectElement, args)}}');
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

  String _generatePluralOptions(PluralElement element, List<Argument> args) {
    var options = <String>[];

    _sanitizePluralOptions(element.options).forEach((option) {
      switch (option.name) {
        case '=0':
        case 'zero':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      zero: '$message',");
            break;
          }
        case '=1':
        case 'one':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      one: '$message',");
            break;
          }
        case '=2':
        case 'two':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      two: '$message',");
            break;
          }
        case 'few':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      few: '$message',");
            break;
          }
        case 'many':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      many: '$message',");
            break;
          }
        case 'other':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      other: '$message',");
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
      warning("Detected plural irregularity for the '$name' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '$name' key lacks mandatory plural form 'other'.");
    }

    for (var option in sanitized) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '$name' key lacks translation for the plural form '${option.name}'.");
      }
    }

    return sanitized;
  }

  String _generateGenderOptions(GenderElement element, List<Argument> args) {
    var options = <String>[];

    _sanitizeGenderOptions(element.options).forEach((option) {
      switch (option.name) {
        case 'male':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      male: '$message',");
            break;
          }
        case 'female':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      female: '$message',");
            break;
          }
        case 'other':
          {
            var message = _generatePluralOrSelectOptionMessage(option, args);
            options.add("      other: '$message',");
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
      warning("Detected gender irregularity for the '$name' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '$name' key lacks mandatory gender form 'other'.");
    }

    for (var option in sanitized) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '$name' key lacks translation for the gender form '${option.name}'.");
      }
    }

    return sanitized;
  }

  String _generateSelectOptions(SelectElement element, List<Argument> args) {
    var options = <String>[];

    options.add('      {');
    _sanitizeSelectOptions(element.options).forEach((option) {
      options.add(
          "        '${option.name}': '${_generatePluralOrSelectOptionMessage(option, args)}',");
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
      warning("Detected select irregularity for the '$name' key.");
    } else if (!uniqueKeys.contains('other')) {
      warning("The '$name' key lacks mandatory select case 'other'.");
    }

    for (var option in sanitized) {
      if (option.value.length == 1 &&
          option.value[0] is LiteralElement &&
          (option.value[0] as LiteralElement).value.isEmpty) {
        warning(
            "The '$name' key lacks translation for the select case '${option.name}'.");
      }
    }

    return sanitized;
  }

  String _generatePluralMessage(PluralElement element, List<Argument> args) {
    var options = <String>[];

    _sanitizePluralOptions(element.options).forEach((option) {
      var message = _generatePluralOrSelectOptionMessage(option, args);

      switch (option.name) {
        case '=0':
        case 'zero':
          {
            options.add("zero: '$message'");
            break;
          }
        case '=1':
        case 'one':
          {
            options.add("one: '$message'");
            break;
          }
        case '=2':
        case 'two':
          {
            options.add("two: '$message'");
            break;
          }
        case 'few':
          {
            options.add("few: '$message'");
            break;
          }
        case 'many':
          {
            options.add("many: '$message'");
            break;
          }
        case 'other':
          {
            options.add("other: '$message'");
            break;
          }
      }
    });

    return 'Intl.plural(${element.value}, ${options.join(', ')})';
  }

  String _generateGenderMessage(GenderElement element, List<Argument> args) {
    var options = <String>[];

    _sanitizeGenderOptions(element.options).forEach((option) {
      var message = _generatePluralOrSelectOptionMessage(option, args);
      switch (option.name) {
        case 'male':
          {
            options.add("male: '$message'");
            break;
          }
        case 'female':
          {
            options.add("female: '$message'");
            break;
          }
        case 'other':
          {
            options.add("other: '$message'");
            break;
          }
        default:
          {}
      }
    });

    return 'Intl.gender(${element.value}, ${options.join(', ')})';
  }

  String _generateSelectMessage(SelectElement element, List<Argument> args) {
    var options = <String>[];

    _sanitizeSelectOptions(element.options).forEach((option) {
      options.add(
          "'${option.name}': '${_generatePluralOrSelectOptionMessage(option, args)}'");
    });

    return 'Intl.select(${element.value}, {${options.join(', ')}})';
  }

  String _generatePluralOrSelectOptionMessage(option, List<Argument> args) {
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
                    var formattedArg = args
                        .singleWhere((element) => element.name == item.value)
                        .formattedName;

                    return MapEntry(
                        index,
                        _isArgumentBracingRequired(data, index)
                            ? '\${$formattedArg}'
                            : '\$$formattedArg');
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
