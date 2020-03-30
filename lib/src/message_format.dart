enum ElementType { literal, argument, plural, gender, select }

class BaseElement {
  ElementType type;
  String value;

  BaseElement(this.type, this.value);
}

class Option {
  String name;
  List<BaseElement> value;

  Option(this.name, this.value);
}

class LiteralElement extends BaseElement {
  LiteralElement(String value) : super(ElementType.literal, value);
}

class ArgumentElement extends BaseElement {
  ArgumentElement(String value) : super(ElementType.argument, value);
}

class GenderElement extends BaseElement {
  List<Option> options;

  GenderElement(String value, this.options) : super(ElementType.gender, value);
}

class PluralElement extends BaseElement {
  List<Option> options;

  PluralElement(String value, this.options) : super(ElementType.plural, value);
}

class SelectElement extends BaseElement {
  List<Option> options;

  SelectElement(String value, this.options) : super(ElementType.select, value);
}
