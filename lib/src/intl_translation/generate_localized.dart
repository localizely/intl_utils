// This file incorporates work covered by the following copyright and
// permission notice:
//
//     Copyright 2013, the Dart project authors. All rights reserved.
//     Redistribution and use in source and binary forms, with or without
//     modification, are permitted provided that the following conditions are
//     met:
//
//         * Redistributions of source code must retain the above copyright
//           notice, this list of conditions and the following disclaimer.
//         * Redistributions in binary form must reproduce the above
//           copyright notice, this list of conditions and the following
//           disclaimer in the documentation and/or other materials provided
//           with the distribution.
//         * Neither the name of Google Inc. nor the names of its
//           contributors may be used to endorse or promote products derived
//           from this software without specific prior written permission.
//
//     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
//     "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
//     LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
//     A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
//     OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
//     SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//     LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//     DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//     THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//     (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//     OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//
// Due to a delay in the maintenance of the 'intl_translation' package,
// we are using a partial copy of it with added support for the null-safety.

// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This provides utilities for generating localized versions of
/// messages. It does not stand alone, but expects to be given
/// TranslatedMessage objects and generate code for a particular locale
/// based on them.
///
/// An example of usage can be found
/// in test/message_extract/generate_from_json.dart
library generate_localized;

import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import './src/intl_message.dart';
import '../utils/utils.dart';

class MessageGeneration {
  /// If the import path following package: is something else, modify the
  /// [intlImportPath] variable to change the import directives in the generated
  /// code.
  var intlImportPath = 'intl';

  /// If the path to the generated files is something other than the current
  /// directory, update the [generatedImportPath] variable to change the import
  /// directives in the generated code.
  var generatedImportPath = '';

  /// Given a base file, return the file prefixed with the path to import it.
  /// By default, that is in the current directory, but if [generatedImportPath]
  /// has been set, then use that as a prefix.
  String importForGeneratedFile(String file) =>
      generatedImportPath.isEmpty ? file : '$generatedImportPath/$file';

  /// A list of all the locales for which we have translations. Code that does
  /// the reading of translations should add to this.
  Set<String> allLocales = {};

  /// If we have more than one set of messages to generate in a particular
  /// directory we may want to prefix some to distinguish them.
  String generatedFilePrefix = '';

  /// Should we use deferred loading for the generated libraries.
  bool useDeferredLoading = true;

  /// The mode to generate in - either 'release' or 'debug'.
  ///
  /// In release mode, a missing translation is an error. In debug mode, it
  /// falls back to the original string.
  String? codegenMode;

  /// What is the path to the package for which we are generating.
  ///
  /// The exact format of this string depends on the generation mechanism,
  /// so it's left undefined.
  String? package;

  bool get releaseMode => codegenMode == 'release';

  bool get jsonMode => false;

  /// Holds the generated translations.
  StringBuffer output = StringBuffer();

  void clearOutput() {
    output = StringBuffer();
  }

  /// Generate a file <[generated_file_prefix]>_messages_<[locale]>.dart
  /// for the [translations] in [locale] and put it in [targetDir].
  void generateIndividualMessageFile(String basicLocale,
      Iterable<TranslatedMessage> translations, String targetDir) {
    final fileName = '${generatedFilePrefix}messages_$basicLocale.dart';
    final content = contentForLocale(basicLocale, translations);
    final formattedContent = formatDartContent(content, fileName);

    // To preserve compatibility, we don't use the canonical version of the
    // locale in the file name.
    final filePath = path.join(targetDir, fileName);
    File(filePath).writeAsStringSync(formattedContent);
  }

  /// Generate a string that contains the dart code
  /// with the [translations] in [locale].
  String contentForLocale(
      String basicLocale, Iterable<TranslatedMessage> translations) {
    clearOutput();
    var locale = MainMessage()
        .escapeAndValidateString(Intl.canonicalizedLocale(basicLocale));
    output.write(prologue(locale));
    // Exclude messages with no translation and translations with no matching
    // original message (e.g. if we're using some messages from a larger
    // catalog)
    var usableTranslations =
        translations.where((each) => each.originalMessages != null).toList();
    for (var each in usableTranslations) {
      for (var original in each.originalMessages!) {
        original.addTranslation(locale, each.message);
      }
    }
    usableTranslations.sort((a, b) => a.originalMessages!.first.name
        .compareTo(b.originalMessages!.first.name));

    writeTranslations(usableTranslations, locale);

    return '$output';
  }

  /// Write out the translated forms.
  void writeTranslations(
      Iterable<TranslatedMessage> usableTranslations, String locale) {
    for (var translation in usableTranslations) {
      // Some messages we generate as methods in this class. Simpler ones
      // we inline in the map from names to messages.
      var messagesThatNeedMethods =
          translation.originalMessages!.where(_hasArguments).toSet().toList();
      for (var original in messagesThatNeedMethods) {
        output
          ..write('  ')
          ..write(
              original.toCodeForLocale(locale, _methodNameFor(original.name)))
          ..write('\n\n');
      }
    }
    output.write(messagesDeclaration);

    // Now write the map of names to either the direct translation or to a
    // method.
    var entries = (usableTranslations
            .expand((translation) => translation.originalMessages!)
            .toSet()
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)))
        .map((original) =>
            '    "${original.escapeAndValidateString(original.name)}" '
            ': ${_mapReference(original, locale)}');
    output
      ..write(entries.join(',\n'))
      ..write('\n  };\n}\n');
  }

  /// Any additional imports the individual message files need.
  String get extraImports => '';

  String get messagesDeclaration =>
      // Includes some gyrations to prevent parts of the deferred libraries from
      // being inlined into the main one, defeating the space savings. Issue
      // 24356
      '''
  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function> {
''';

  /// [generateIndividualMessageFile] for the beginning of the file,
  /// parameterized by [locale].
  String prologue(String locale) =>
      """
// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a $locale locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:$intlImportPath/intl.dart';
import 'package:$intlImportPath/message_lookup_by_library.dart';
$extraImports
final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => '$locale';

""" +
      (releaseMode ? overrideLookup : '');

  String overrideLookup = """
  String lookupMessage(
      String message_str,
      String locale,
      String name,
      List<dynamic> args,
      String meaning,
      {MessageIfAbsent ifAbsent}) {
    String failedLookup(String message_str, List<dynamic> args) {
      // If there's no message_str, then we are an internal lookup, e.g. an
      // embedded plural, and shouldn't fail.
      if (message_str == null) return null;
      throw new UnsupportedError(
          "No translation found for message '\$name',\\n"
          "  original text '\$message_str'");
    }
    return super.lookupMessage(message_str, locale, name, args, meaning,
        ifAbsent: ifAbsent ?? failedLookup);
  }

""";

  /// This section generates the messages_all.dart file based on the list of
  /// [allLocales].
  String generateMainImportFile() {
    clearOutput();
    output.write(mainPrologue);
    for (var locale in allLocales) {
      var baseFile = '${generatedFilePrefix}messages_$locale.dart';
      var file = importForGeneratedFile(baseFile);
      output.write("import '$file' ");
      if (useDeferredLoading) output.write('deferred ');
      output.write('as ${libraryName(locale)};\n');
    }
    output.write('\n');
    output.write('typedef Future<dynamic> LibraryLoader();\n');
    output.write('Map<String, LibraryLoader> _deferredLibraries = {\n');
    for (var rawLocale in allLocales) {
      var locale = Intl.canonicalizedLocale(rawLocale);
      var loadOperation = (useDeferredLoading)
          ? "  '$locale': ${libraryName(locale)}.loadLibrary,\n"
          : "  '$locale': () => new Future.value(null),\n";
      output.write(loadOperation);
    }
    output.write('};\n');
    output.write('\nMessageLookupByLibrary? _findExact(String localeName) {\n'
        '  switch (localeName) {\n');
    for (var rawLocale in allLocales) {
      var locale = Intl.canonicalizedLocale(rawLocale);
      output.write(
          "    case '$locale':\n      return ${libraryName(locale)}.messages;\n");
    }
    output.write(closing);
    return output.toString();
  }

  /// Constant string used in [generateMainImportFile] for the beginning of the
  /// file.
  String get mainPrologue => """
// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:implementation_imports, file_names, unnecessary_new
// ignore_for_file:unnecessary_brace_in_string_interps, directives_ordering
// ignore_for_file:argument_type_not_assignable, invalid_assignment
// ignore_for_file:prefer_single_quotes, prefer_generic_function_type_aliases
// ignore_for_file:comment_references

import 'dart:async';

import 'package:$intlImportPath/intl.dart';
import 'package:$intlImportPath/message_lookup_by_library.dart';
import 'package:$intlImportPath/src/intl_helpers.dart';

""";

  /// Constant string used in [generateMainImportFile] as the end of the file.
  String get closing => '''
    default:\n      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
    localeName,
    (locale) => _deferredLibraries[locale] != null,
    onFailure: (_) => null);
  if (availableLocale == null) {
    return new Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? new Future.value(false) : lib());
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);
  return new Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary? _findGeneratedMessagesFor(String locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
''';
}

class JsonMessageGeneration extends MessageGeneration {
  /// We import the main file so as to get the shared code to evaluate
  /// the JSON data.
  @override
  String get extraImports => '''
import 'dart:convert';
import '${generatedFilePrefix}messages_all.dart' show evaluateJsonTemplate;
''';

  @override
  String prologue(locale) =>
      super.prologue(locale) +
      '''
  String evaluateMessage(translation, List<dynamic> args) {
    return evaluateJsonTemplate(translation, args);
  }
''';

  /// Embed the JSON string in a Dart raw string literal.
  ///
  /// In simple cases this just wraps it in a Dart raw triple-quoted
  /// literal. However, a translated message may contain a triple quote,
  /// which would end the Dart literal. So when we encounter this, we turn
  /// it into three adjacent strings, one of which is just the
  /// triple-quote.
  String _embedInLiteral(String jsonMessages) {
    var triple = "'''";
    var result = jsonMessages;
    if (jsonMessages.contains(triple)) {
      var doubleQuote = '"';
      var asAdjacentStrings =
          '$triple  r$doubleQuote$triple$doubleQuote r$triple';
      result = jsonMessages.replaceAll(triple, asAdjacentStrings);
    }
    return "r'''\n$result''';\n}";
  }

  @override
  void writeTranslations(
      Iterable<TranslatedMessage> usableTranslations, String locale) {
    output.write(r'''
  Map<String, dynamic> _messages;
  Map<String, dynamic> get messages => _messages ??=
      const JsonDecoder().convert(messageText) as Map<String, dynamic>;
''');

    output.write('  static final messageText = ');
    var entries = usableTranslations
        .expand((translation) => translation.originalMessages!);
    var map = {};
    for (var original in entries) {
      map[original.name] = original.toJsonForLocale(locale);
    }
    var jsonEncoded = JsonEncoder().convert(map);
    output.write(_embedInLiteral(jsonEncoded));
  }

  @override
  String get closing =>
      super.closing +
      '''
/// Turn the JSON template into a string.
///
/// We expect one of the following forms for the template.
/// * null -> null
/// * String s -> s
/// * int n -> '\${args[n]}'
/// * List list, one of
///   * ['Intl.plural', int howMany, (templates for zero, one, ...)]
///   * ['Intl.gender', String gender, (templates for female, male, other)]
///   * ['Intl.select', String choice, { 'case' : template, ...}]
///   * ['text alternating with ', 0 , ' indexes in the argument list']
String evaluateJsonTemplate(dynamic input, List<dynamic> args) {
  if (input == null) return null;
  if (input is String) return input;
  if (input is int) {
    return "\${args[input]}";
  }

  var template = input as List<dynamic>;
  var messageName = template.first;
  if (messageName == "Intl.plural") {
     var howMany = args[template[1] as int] as num;
     return evaluateJsonTemplate(
         Intl.pluralLogic(
             howMany,
             zero: template[2],
             one: template[3],
             two: template[4],
             few: template[5],
             many: template[6],
             other: template[7]),
         args);
   }
   if (messageName == "Intl.gender") {
     var gender = args[template[1] as int] as String;
     return evaluateJsonTemplate(
         Intl.genderLogic(
             gender,
             female: template[2],
             male: template[3],
             other: template[4]),
         args);
   }
   if (messageName == "Intl.select") {
     var select = args[template[1] as int];
     var choices = template[2] as Map<Object, Object>;
     return evaluateJsonTemplate(Intl.selectLogic(select, choices), args);
   }

   // If we get this far, then we are a basic interpolation, just strings and
   // ints.
   var output = new StringBuffer();
   for (var entry in template) {
     if (entry is int) {
       output.write("\${args[entry]}");
     } else {
       output.write("\$entry");
     }
   }
   return output.toString();
  }

 ''';
}

/// This represents a message and its translation. We assume that the
/// translation has some identifier that allows us to figure out the original
/// message it corresponds to, and that it may want to transform the translated
/// text in some way, e.g. to turn whatever format the translation uses for
/// variables into a Dart string interpolation. Specific translation mechanisms
/// are expected to subclass this.
abstract class TranslatedMessage {
  /// The identifier for this message. In the simplest case, this is the name
  /// parameter from the Intl.message call,
  /// but it can be any identifier that this program and the output of the
  /// translation can agree on as identifying a message.
  final String id;

  /// Our translated version of all the [originalMessages].
  final Message translated;

  /// The original messages that we are a translation of. There can
  ///  be more than one original message for the same translation.
  List<MainMessage>? originalMessages;

  /// For backward compatibility, we still have the originalMessage API.
  MainMessage? get originalMessage => originalMessages?.first;
  set originalMessage(MainMessage? m) {
    if (m != null) {
      originalMessages = [m];
    }
  }

  TranslatedMessage(this.id, this.translated);

  Message get message => translated;

  @override
  String toString() => id.toString();

  @override
  bool operator ==(Object other) =>
      other is TranslatedMessage && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// We can't use a hyphen in a Dart library name, so convert the locale
/// separator to an underscore.
String libraryName(String x) =>
    'messages_' + x.replaceAll('-', '_').toLowerCase();

bool _hasArguments(MainMessage message) =>
    message.arguments != null && message.arguments!.isNotEmpty;

///  Simple messages are printed directly in the map of message names to
///  functions as a call that returns a lambda. e.g.
///
///        "foo" : simpleMessage("This is foo"),
///
///  This is helpful for the compiler.
/// */
String _mapReference(MainMessage original, String locale) {
  if (!_hasArguments(original)) {
    // No parameters, can be printed simply.
    return 'MessageLookupByLibrary.simpleMessage("'
        '${original.translations[locale]}")';
  } else {
    return _methodNameFor(original.name);
  }
}

/// Generated method counter for use in [_methodNameFor].
int _methodNameCounter = 0;

/// A map from Intl message names to the generated method names
/// for their translated versions.
Map<String, String> _internalMethodNames = {};

/// Generate a Dart method name of the form "m<number>".
String _methodNameFor(String name) {
  return _internalMethodNames.putIfAbsent(
      name, () => 'm${_methodNameCounter++}');
}
