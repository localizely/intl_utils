## Intl Utils

[![pub package](https://img.shields.io/pub/v/intl_utils.svg)](https://pub.dev/packages/intl_utils)

Dart package that creates a binding between your translations from .arb files and your Flutter app. It generates boilerplate code for official Dart Intl library and adds auto-complete for keys in Dart code.

Follow us on [Twitter](https://twitter.com/localizely "Follow us on Twitter").

## Usage

You can use this package directly (i.e. for Continuous Integration tools or via CLI) or leave it to [Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) or [IntelliJ/Android Studio](https://plugins.jetbrains.com/plugin/13666-flutter-intl) plugins to run it automatically whenever you modify ARB files.

Follow these steps to get started:

### Configure package

Add package configuration to your `pubspec.yaml` file. Here is a full configuration for the package:

<pre>
flutter_intl:
  <b>enabled: true</b> # Required. Must be set to true to activate the package. Default: false
  class_name: S # Optional. Sets the name for the generated localization class. Default: S
  main_locale: en # Optional. Sets the main locale used for generating localization files. Provided value should consist of language code and optional script and country codes separated with underscore (e.g. 'en', 'en_GB', 'zh_Hans', 'zh_Hans_CN'). Default: en
  arb_dir: lib/l10n # Optional. Sets the directory of your ARB resource files. Provided value should be a valid path on your system. Default: lib/l10n
  output_dir: lib/generated # Optional. Sets the directory of generated localization files. Provided value should be a valid path on your system. Default: lib/generated
  use_deferred_loading: false # Optional. Must be set to true to generate localization code that is loaded with deferred loading. Default: false
  localizely: # Optional settings if you use Localizely platform. Read more: https://localizely.com/flutter-localization-workflow
    project_id: # Get it from the https://app.localizely.com/projects page.
    branch: # Get it from the “Branches” page on the Localizely platform, in case branching is enabled and you want to use a non-main branch.
    upload_overwrite: # Set to true if you want to overwrite translations with upload. Default: false
    upload_as_reviewed: # Set to true if you want to mark uploaded translations as reviewed. Default: false
    download_empty_as: # Set to empty|main|skip, to configure how empty translations should be exported from the Localizely platform. Default: empty
    ota_enabled: # Set to true if you want to use Localizely Over-the-air functionality. Default: false
</pre>

### Add ARB files

Add one ARB file for each locale you need to support in your Flutter app.
Add them to `lib/l10n` folder inside your project, and name them in a following way: `intl_<LOCALE_ISO_CODE>.arb`.  
For example: `intl_en.arb` or `intl_en_GB.arb`.
You can also change the ARB folder from `lib/l10n` to a custom directory by adding the `arb_dir` line in your `pubspec.yaml` file.

If you wonder how to format key-values content inside ARB files, [here](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification) is detailed explanation.

### Run command

To generate boilerplate code for localization, run the `generate` program inside directory where your `pubspec.yaml` file is located:

      flutter pub run intl_utils:generate

This will produce files inside `lib/generated` directory.
You can also change the output folder from `lib/generated` to a custom directory by adding the `output_dir` line in your `pubspec.yaml` file.

### Integration with Localizely

#### Upload main ARB file

      flutter pub run intl_utils:localizely_upload_main [--project-id <PROJECT_ID> --api-token <API_TOKEN> --arb-dir <ARB_DIR> --main-locale <MAIN_LOCALE> --branch <BRANCH> --[no-]upload-overwrite --[no-]upload-as-reviewed]

This will upload your main ARB file to Localizely.<br />All args are optional. If not provided, the `intl_utils` will use configuration from the `pubspec.yaml` file or default values (check the [Configure package](#configure-package) section for more details).

#### Download ARB files

      flutter pub run intl_utils:localizely_download [--project-id <PROJECT_ID> --api-token <API_TOKEN> --arb-dir <ARB_DIR> --download-empty-as <DOWNLOAD_EMPTY_AS> --branch <BRANCH>]

This will download all available ARB files from the Localizely platform and put them under `arb-dir` folder.<br />All args are optional. If not provided, the `intl_utils` will use configuration from the `pubspec.yaml` file or default values (check the [Configure package](#configure-package) section for more details).

Notes:  
Argument `project-id` can be omitted if `pubspec.yaml` file contains `project_id` configuration under `flutter_intl/localizely` section.  
Argument `api-token` can be omitted if `~/.localizely/credentials.yaml` file contains `api_token` configuration.  
Optional argument `arb-dir` has the value `lib/l10n` as default and needs only to be set, if you want to place your ARB files in a custom directory.
