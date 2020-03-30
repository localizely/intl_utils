import 'package:petitparser/petitparser.dart';

import 'package:intl_utils/src/message_format.dart';

class Parser {
  get openCurly => char("{");
  get closeCurly => char("}");
  get quotedCurly => (string("'{'") | string("'}'")).map((x) => x[1]);
  get icuEscapedText => quotedCurly | twoSingleQuotes;
  get curly => (openCurly | closeCurly);
  get notAllowedInIcuText => curly | char("<");
  get icuText => notAllowedInIcuText.neg();
  get notAllowedInNormalText => char("{");
  get normalText => notAllowedInNormalText.neg();
  get messageText => (icuEscapedText | icuText).plus().flatten().map((result) => LiteralElement(result));
  get nonIcuMessageText => normalText.plus().flatten().map((result) => LiteralElement(result));
  get twoSingleQuotes => string("''").map((x) => "'");
  get number => digit().plus().flatten().trim().map(int.parse);
  get id => (letter() & (word() | char("_")).star()).flatten().trim();
  get comma => char(",").trim();

  /// Given a list of possible keywords, return a rule that accepts any of them.
  /// e.g., given ["male", "female", "other"], accept any of them.
  asKeywords(list) => list.map(string).reduce((a, b) => a | b).flatten().trim();

  get pluralKeyword => asKeywords(["=0", "=1", "=2", "zero", "one", "two", "few", "many", "other"]);
  get genderKeyword => asKeywords(["female", "male", "other"]);

  var interiorText = undefined();

  get preface => (openCurly & id & comma).map((values) => values[1]);

  get pluralLiteral => string("plural");
  get pluralClause => (pluralKeyword & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  get plural => preface & pluralLiteral & comma & pluralClause.plus() & closeCurly;
  get intlPlural => plural.map((result) => PluralElement(result[0], List<Option>.from(result[3])));

  get selectLiteral => string("select");
  get genderClause => (genderKeyword & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  get gender => preface & selectLiteral & comma & genderClause.plus() & closeCurly;
  get intlGender => gender.map((result) => GenderElement(result[0], List<Option>.from(result[3])));
  get selectClause => (id & openCurly & interiorText & closeCurly)
      .trim()
      .map((result) => Option(result[0], List<BaseElement>.from(result[2] is List ? result[2] : [result[2]])));
  get generalSelect => preface & selectLiteral & comma & selectClause.plus() & closeCurly;
  get intlSelect => generalSelect.map((result) => SelectElement(result[0], List<Option>.from(result[3])));

  get pluralOrGenderOrSelect => (intlPlural | intlGender | intlSelect);

  get contents => pluralOrGenderOrSelect | parameter | messageText;
  get simpleText => (nonIcuMessageText | parameter | openCurly).plus();
  get empty => epsilon().map((_) => LiteralElement(""));

  get parameter => (openCurly & id & closeCurly).map((result) => ArgumentElement(result[1]));

  List<BaseElement> parse(String message) {
    var parsed = (pluralOrGenderOrSelect | simpleText | empty)
        .map((result) => List<BaseElement>.from(result is List ? result : [result]))
        .parse(message);
    return parsed.isSuccess ? parsed.value : null;
  }

  Parser() {
    // There is a cycle here, so we need the explicit set to avoid infinite recursion.
    interiorText.set(contents.plus() | empty);
  }
}
