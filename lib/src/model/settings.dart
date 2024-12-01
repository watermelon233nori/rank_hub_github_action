class SettingsModel {
  bool isDarkMode;
  String themeColor;
  String language;
  Duration playerDataCacheDuration;
  Duration gameDataCacheDuration;

  SettingsModel({
    required this.isDarkMode,
    required this.themeColor,
    required this.language,
    required this.playerDataCacheDuration,
    required this.gameDataCacheDuration,
  });
}
