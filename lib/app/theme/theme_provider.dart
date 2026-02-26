import 'package:digital_wallett_system/core/services/storage/user_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme mode provider
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
final lightSensorThemeEnabledProvider =
    NotifierProvider<LightSensorThemeNotifier, bool>(
      LightSensorThemeNotifier.new,
    );

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  static const String _themeManuallySetKey = 'theme_mode_manually_set';

  @override
  ThemeMode build() {
    // Load saved theme from SharedPreferences synchronously
    final prefs = ref.read(sharedPreferencesProvider);
    final themeValue = prefs.getString(_themeKey);
    if (themeValue != null) {
      return _themeModeFromString(themeValue);
    }
    return ThemeMode.light;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = mode;
    await prefs.setBool(_themeManuallySetKey, true);
    await prefs.setString(_themeKey, _themeModeToString(mode));
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }

  Future<void> setThemeModeFromLightSensor(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state != mode) {
      state = mode;
    }
    await prefs.setBool(_themeManuallySetKey, false);
    await prefs.setString(_themeKey, _themeModeToString(mode));
  }

  bool get isDarkMode => state == ThemeMode.dark;

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }
}

class LightSensorThemeNotifier extends Notifier<bool> {
  static const String _lightSensorThemeEnabledKey =
      'light_sensor_theme_enabled';

  @override
  bool build() {
    final prefs = ref.read(sharedPreferencesProvider);
    return prefs.getBool(_lightSensorThemeEnabledKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = value;
    await prefs.setBool(_lightSensorThemeEnabledKey, value);
  }
}
