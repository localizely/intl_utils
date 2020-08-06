# Change Log

All notable changes to the "flutter-intl" extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.6.3 - 2020-08-06

- Update `petitparser` dependency

## 1.6.2 - 2020-06-22

- Update file logic

- Code cleanup

## 1.6.1 - 2020-06-17

- Add useful error message for invalid ARB files

## 1.6.0 - 2020-06-03

- Reference the key without passing the context

- Provide default value of term as Dart doc on getters in `l10n.dart` file

- Suppress lint warnings for getters that do not follow the lowerCamelCase style within `l10n.dart` file

## 1.5.0 - 2020-05-11

- Add support for the Localizely SDK

- Fix lint warnings for the `l10n.dart` file

## 1.4.0 - 2020-05-04

- Add integration with Localizely

## 1.3.0 - 2020-04-21

- Support select messages 

- Make order of supported locales consistent

## 1.2.2 - 2020-04-13

- Make generated files consistent

## 1.2.1 - 2020-03-30

- Update order of supported locales

- Replace `dynamic` with concrete type for generated Dart methods

- Handle empty plural and gender forms

- Update `l10n.dart` file template (remove `localeName`)

## 1.2.0 - 2020-03-16

- Add support for locales with script code

- Fix locale loading issue when country code is not provided

## 1.1.0 - 2020-02-04

- Make main locale configurable

## 1.0.2 - 2020-01-21

- Add curly-braces around placeholders when they are followed by alphanumeric or underscore character

## 1.0.1 - 2020-01-15

- Fix trailing comma issue (l10n.dart)

- Remove unused dependencies

## 1.0.0 - 2020-01-12

- Initial release
