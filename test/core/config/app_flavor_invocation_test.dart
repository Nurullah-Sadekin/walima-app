import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';

void main() {
  const selectedFlavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  test('APP_FLAVOR initializes the matching configuration', () {
    AppConfig.initialize();

    final expected = AppConfig.fromFlavorName(selectedFlavor);
    expect(AppConfig.instance.flavor, expected.flavor);
    expect(AppConfig.instance.apiBaseUrl, expected.apiBaseUrl);
    expect(AppConfig.instance.imageBaseUrl, expected.imageBaseUrl);
  });
}
