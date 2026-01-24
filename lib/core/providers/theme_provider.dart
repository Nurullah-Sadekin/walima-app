import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Theme mode provider
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const String _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  /// Load theme from shared preferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 0;
    state = ThemeMode.values[themeIndex];
  }

  /// Save theme to shared preferences
  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
    await _saveTheme(state);
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _saveTheme(mode);
  }

  /// Set light theme
  Future<void> setLightTheme() async {
    state = ThemeMode.light;
    await _saveTheme(state);
  }

  /// Set dark theme
  Future<void> setDarkTheme() async {
    state = ThemeMode.dark;
    await _saveTheme(state);
  }

  /// Set system theme
  Future<void> setSystemTheme() async {
    state = ThemeMode.system;
    await _saveTheme(state);
  }

  /// Check if dark mode is enabled
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if light mode is enabled
  bool get isLightMode => state == ThemeMode.light;

  /// Check if system mode is enabled
  bool get isSystemMode => state == ThemeMode.system;
}
