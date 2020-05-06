class PubspecConfig {
  bool enabled;
  String className;
  String mainLocale;
  LocalizelyConfig localizelyConfig;

  PubspecConfig(this.enabled, this.className, this.mainLocale, this.localizelyConfig);
}

class LocalizelyConfig {
  String projectId;
  bool uploadAsReviewed;
  bool uploadOverwrite;

  LocalizelyConfig(this.projectId, this.uploadAsReviewed, this.uploadOverwrite);
}
