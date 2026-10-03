import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walima_llc/core/constants/storage_keys.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('logout keeps only saved onboarding data', () async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.accessToken: 'access',
      StorageKeys.refreshToken: 'refresh',
      StorageKeys.fcmToken: 'fcm',
      StorageKeys.meSnapshot: '{}',
      StorageKeys.quotaSnapshot: '{}',
      StorageKeys.deviceId: 'device',
      StorageKeys.notificationPermissionAsked: true,
      StorageKeys.registrationDraft: '{"step":2}',
      StorageKeys.registrationVerificationDone: true,
      'theme_mode': 1,
      'locale': 'bn',
      'other_cached_value': 'stale',
    });

    await PrefsHelper.clearForLogout();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getKeys(), {
      StorageKeys.registrationDraft,
      StorageKeys.registrationVerificationDone,
    });
    expect(prefs.getString(StorageKeys.registrationDraft), '{"step":2}');
    expect(prefs.getBool(StorageKeys.registrationVerificationDone), isTrue);
  });
}
