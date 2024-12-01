import 'package:flutter/material.dart';
import 'package:rank_hub/src/model/settings.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsModel settings = SettingsModel(
    isDarkMode: false,
    themeColor: 'Blue',
    language: 'English',
    playerDataCacheDuration: const Duration(hours: 1),
    gameDataCacheDuration: const Duration(hours: 23),
  );

  void toggleDarkMode(bool value) {
    settings.isDarkMode = value;
    notifyListeners();
  }

  void updateThemeColor(String color) {
    settings.themeColor = color;
    notifyListeners();
  }

  void updateLanguage(String language) {
    settings.language = language;
    notifyListeners();
  }

  void updatePlayerCacheDuration(Duration duration) {
    settings.playerDataCacheDuration = duration;
    notifyListeners();
  }

  void updateGameCacheDuration(Duration duration) {
    settings.gameDataCacheDuration = duration;
    notifyListeners();
  }

  void clearCache() {
    // 清除缓存逻辑
    print("Cache cleared!");
    notifyListeners();
  }

  void exportPlayerData() {
    // 导出数据逻辑
    print("Player data exported!");
  }

  void importPlayerData() {
    // 导入数据逻辑
    print("Player data imported!");
  }
}
