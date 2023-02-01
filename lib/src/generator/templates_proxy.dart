import 'label.dart';

String generateL10nProxyDartFileContent( bool flutter, String className, List<Label> labels, List<String> locales) {
    return """
// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:intl/message_lookup_by_library.dart';
${_generateLocaleImport(locales)}

// **************************************************************************
// Generator: Intl IDE plugin
// Made by acorn371
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class _DummyMessageLookup extends MessageLookupByLibrary {
  final String localeName;

  _DummyMessageLookup(this.localeName);
  
  dynamic operator [](String messageName) => MessageLookupByLibrary.simpleMessage("(unknown locale '\$localeName') \$messageName");
  
  @override
  Map<String, dynamic> get messages => {};
}

MessageLookupByLibrary _find(String localeName) {
  switch (localeName) {
    ${_generateLocaleCase(locales, "\t\t")}
    default:
      return _DummyMessageLookup(localeName);
  }
}

class $className {
  ${_generateMessages(labels,"\t")}
}

""".trim();
}


String _generateLocaleImport(List<String> locales) {
  final StringBuffer buffer = StringBuffer();
  for( final locale in locales)
    buffer.writeln("import 'intl/messages_$locale.dart' as messages_$locale;");

  return buffer.toString();
}

String _generateLocaleCase(List<String> locales, String padding) {
  final StringBuffer buffer = StringBuffer();
  for( final locale in locales)
    buffer..writeln("${padding}case '$locale':")..writeln("${padding}\treturn messages_$locale.messages;");

  return buffer.toString();
}

String _generateMessages(List<Label> labels, String padding) {
  final StringBuffer buffer = StringBuffer();
  for( final label in labels)
    buffer.writeln("${padding}static String ${label.name}(String localeName) => _find(localeName)['${label.name}']();");

  return buffer.toString();
}