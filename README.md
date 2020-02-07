## Intl Utils

Dart package that creates a binding between your translations from .arb files and your Flutter app. It generates boilerplate code for official Dart Intl library and adds auto-complete for keys in Dart code.

## Usage

You can use this package directly (ie for Continuous Integration tools or via CLI) or leave it to [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) or [IntelliJ/Android Studio](https://plugins.jetbrains.com/plugin/13666-flutter-intl) plugins to run it automatically whenever you modify ARB files.

Follow these steps to get started:

### Configure package

Add package configuration to your `pubspec.yaml` file. Here is a full configuration for the package:

<pre>
flutter_intl:
  <b>enabled: true</b> # Required. Must be set to true to activate the package. Default: false
  class_name: S # Optional. Sets the name for the generated localization class. Default: S
  main_locale: en # Optional. Sets the main locale used for generating localization files. Provided value should comply with ISO-639-1 and ISO-3166-1 (e.g. "en", "en_GB"). Default: en
</pre>

### Add ARB files

Add one ARB file for each locale you need to support in your Flutter app.
Add them to `lib/l10n` folder inside your project, and name them in a following way: `intl_<LOCALE_ISO_CODE>.arb`.
For example: `intl_en.arb` or `intl_en_GB.arb`.

If you wonder how to format key-values content inside ARB files, [here](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification) is detailed explanation.

### Run command

To generate boilerplate code for localization, run the `generate` program inside directory where you `pubspec.yaml` file is located:

      pub run intl_utils:generate

This will produce files inside `lib/generated` directory.
