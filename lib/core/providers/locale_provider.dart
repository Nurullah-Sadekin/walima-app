import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

/// Locale provider for managing app language
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  static const String _localeKey = 'locale';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en');
  }

  /// Load locale from shared preferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    if (localeCode != null) {
      state = Locale(localeCode);
    }
  }

  /// Save locale to shared preferences
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Set locale
  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _saveLocale(locale);
  }

  /// Set English locale
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }

  /// Set Bangla locale
  Future<void> setBangla() async {
    await setLocale(const Locale('bn'));
  }

  /// Toggle between English and Bangla
  Future<void> toggleLocale() async {
    if (state.languageCode == 'en') {
      await setBangla();
    } else {
      await setEnglish();
    }
  }

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';

  /// Check if current locale is Bangla
  bool get isBangla => state.languageCode == 'bn';
}
