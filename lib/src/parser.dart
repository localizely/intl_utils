import 'package:petitparser/petitparser.dart';

import 'package:intl_utils/src/message_format.dart';

class IcuParser {
  Parser get openCurly => char('{');
  Parser get closeCurly => char('}');
  Parser get quotedCurly => (string("'{'") | string("'}'")).map((x) => x[1]);
  Parser get icuEscapedText => quotedCurly | twoSingleQuotes;
  Parser get curly => (openCurly | closeCurly);
  Parser get notAllowedInIcuText => curly | char('<');
  Parser get icuText => notAllowedInIcuText.neg();
  Parser get notAllowedInNormalText => char('{');
  Parser get normalText => notAllowedInNormalText.neg();
  Parser get messageText => (icuEscapedText | icuText).plus().flatten().map((result) => LiteralElement(result));
  Parser get nonIcuMessageText => normalText.plus().flatten().map((result) => LiteralElement(result));
  Parser get twoSingleQuotes => string("''").map((x) => "'");
  Parser get number => digit().plus().flatten().trim().map(int.parse);
  Parser get id => (letter() & (word() | char('_')).star()).flatten().trim();
  Parser get comma => char(',').trim();

  /// Given a list of possible keywords, return a rule that accepts any of them.
  /// e.g., given ["male", "female", "other"], accept any of them.
  Parser asKeywords(List<String> list) => list.map(string).cast<Parser>().reduce((a, b) => a | b).flatten().trim();

  Parser get pluralKeyword => asKeywords(['=0', '=1', '=2', 'zero', 'one', 'two', 'few', 'many', 'other']);
  Parser get genderKeyword => asKeywords(['female', 'male', 'other']);

  var interiorText = undefined();

  Parser get preface => (openCurly & id & comma).map((values) => values[1]);

  Parser get pluralLiteral => string('plural');
  Parser get pluralClause => (pluralKeyword & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  Parser get plural => preface & pluralLiteral & comma & pluralClause.plus() & closeCurly;
  Parser get intlPlural => plural.map((result) => PluralElement(result[0], List<Option>.from(result[3])));

  Parser get selectLiteral => string('select');
  Parser get genderClause => (genderKeyword & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  Parser get gender => preface & selectLiteral & comma & genderClause.plus() & closeCurly;
  Parser get intlGender => gender.map((result) => GenderElement(result[0], List<Option>.from(result[3])));
  Parser get selectClause => (id & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  Parser get generalSelect => preface & selectLiteral & comma & selectClause.plus() & closeCurly;
  Parser get intlSelect => generalSelect.map((result) => SelectElement(result[0], List<Option>.from(result[3])));

  Parser get pluralOrGenderOrSelect => (intlPlural | intlGender | intlSelect);

  Parser get contents => pluralOrGenderOrSelect | parameter | messageText;
  Parser get simpleText => (nonIcuMessageText | parameter | openCurly).plus();
  Parser get empty => epsilon().map((_) => LiteralElement(''));

  Parser get parameter => (openCurly & id & closeCurly).map((result) => ArgumentElement(result[1]));

  List<BaseElement> parse(String message) {
    var parsed = (pluralOrGenderOrSelect | simpleText | empty)
        .map((result) => List<BaseElement>.from(result is List ? result : [result]))
        .parse(message);
    return parsed.isSuccess ? parsed.value : null;
  }

  IcuParser() {
    // There is a cycle here, so we need the explicit set to avoid infinite recursion.
    interiorText.set(contents.plus() | empty);
  }
}
