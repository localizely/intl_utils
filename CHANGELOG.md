# Change Log

All notable changes to the "flutter-intl" extension will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.6.1 - 2022-01-14

- Improve error handling for invalid config files

- Update `analyzer` dependency

## 2.6.0 - 2021-12-24

- Add custom date-time format option

## 2.5.1 - 2021-11-08

- Fix optional parameters string issue

## 2.5.0 - 2021-11-05

- Add support for json strings

- Add number and date-time format options

- Move from pedantic to lints package

## 2.4.1 - 2021-10-01

- Update `analyzer` dependency

## 2.4.0 - 2021-07-13

- Add support for tagging uploaded string keys to Localizely

- Add support for download tagged string keys from Localizely

- Fix issue with translations that contain tags

## 2.3.0 - 2021-05-18

- Add missing upload and download command line arg options

## 2.2.0 - 2021-04-27

- Add support for compound messages

- Format generated files

- Add missing return types in generated files

- Ignore avoid_escaping_inner_quotes lint rule in generated files

- Fix escaping special chars

## 2.1.0 - 2021-03-09

- Make `of(context)` non-null

## 2.0.0 - 2021-03-05

- Migrate to null-safety

## 1.9.0 - 2020-10-19

- Make generated directory path configurable

- Extend configuration with deferred loading parameter

- Ignore common lint warnings for the `l10n.dart` file

## 1.8.0 - 2020-10-09

- Extend Localizely configuration with the download_empty_as parameter used for setting a fallback for empty translations during download

## 1.7.0 - 2020-09-29

- Make ARB directory path configurable

## 1.6.5 - 2020-09-18

- Fix unzipping issues during download

## 1.6.4 - 2020-09-03

- Extend Localizely configuration with the branch parameter

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
