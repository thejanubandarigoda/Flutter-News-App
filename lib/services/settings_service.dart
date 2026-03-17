import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Keys
  static const _keyDarkMode = 'dark_mode';
  static const _keyCountry = 'country';
  static const _keyCategory = 'default_category';
  static const _keyFontSize = 'font_size';

  // Defaults
  static const String defaultCountry = 'us';
  static const String defaultCategory = 'general';
  static const double defaultFontSize = 14.0;

  // In-memory notifiers — the rest of the app listens to these
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.light);
  static final ValueNotifier<String> countryNotifier =
      ValueNotifier(defaultCountry);
  static final ValueNotifier<String> categoryNotifier =
      ValueNotifier(defaultCategory);
  static final ValueNotifier<double> fontSizeNotifier =
      ValueNotifier(defaultFontSize);

  /// Call once at app startup (before runApp)
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final isDark = prefs.getBool(_keyDarkMode) ?? false;
    themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;

    countryNotifier.value = prefs.getString(_keyCountry) ?? defaultCountry;
    categoryNotifier.value = prefs.getString(_keyCategory) ?? defaultCategory;
    fontSizeNotifier.value =
        prefs.getDouble(_keyFontSize) ?? defaultFontSize;
  }

  static Future<void> setDarkMode(bool value) async {
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  static Future<void> setCountry(String value) async {
    countryNotifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCountry, value);
  }

  static Future<void> setDefaultCategory(String value) async {
    categoryNotifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCategory, value);
  }

  static Future<void> setFontSize(double value) async {
    fontSizeNotifier.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyFontSize, value);
  }

  static bool get isDarkMode => themeNotifier.value == ThemeMode.dark;
}
