import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';

void main() {
  group('AppConfig', () {
    test('parses supported flavors case-insensitively', () {
      expect(AppConfig.fromFlavorName('dev').flavor, AppFlavor.dev);
      expect(AppConfig.fromFlavorName(' PROD ').flavor, AppFlavor.prod);
    });

    test('rejects unsupported flavors', () {
      expect(
        () => AppConfig.fromFlavorName('staging'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('selects development URLs', () {
      final config = AppConfig.fromFlavorName('dev');

      expect(config.isDev, isTrue);
      expect(config.isProd, isFalse);
      expect(config.apiBaseUrl, 'https://dev.walima.app/api/v1');
      expect(config.imageBaseUrl, 'https://dev.walima.app/');
    });

    test('selects production URLs', () {
      final config = AppConfig.fromFlavorName('prod');

      expect(config.isDev, isFalse);
      expect(config.isProd, isTrue);
      expect(config.apiBaseUrl, 'https://walima.app/api/v1');
      expect(config.imageBaseUrl, 'https://walima.app/');
    });
  });
}
