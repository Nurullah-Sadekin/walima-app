import 'package:flutter_boilerplate/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static Future<String> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(StorageKeys.accessToken);
    return token ?? '';
  }

  static Future<String> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(StorageKeys.refreshToken);
    return token ?? '';
  }

  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.accessToken, token);
  }

  static Future<void> setRefreshToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.refreshToken, token);
  }

  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.accessToken);
    await prefs.remove(StorageKeys.refreshToken);
  }

  static Future<void> setRegistrationDraft(String draftJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.registrationDraft, draftJson);
  }

  static Future<String> getRegistrationDraft() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.registrationDraft) ?? '';
  }

  static Future<void> setRegistrationVerificationDone(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(StorageKeys.registrationVerificationDone, value);
  }

  static Future<bool> getRegistrationVerificationDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(StorageKeys.registrationVerificationDone) ?? false;
  }

  static Future<void> clearRegistrationDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.registrationDraft);
    await prefs.remove(StorageKeys.registrationVerificationDone);
  }
}
