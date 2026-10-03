import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/login/presentation/providers/login_provider.dart';

void main() {
  test('phone authentication identifier includes selected dial code', () {
    final provider = LoginProvider();
    provider.mobileNoOrEmailController.text = '1712345678';
    provider.setPhoneDialCode('+880');

    expect(provider.authIdentifier, '+8801712345678');

    provider.setPhoneDialCode('+44');
    expect(provider.authIdentifier, '+441712345678');
  });

  test('email authentication identifier remains unchanged', () {
    final provider = LoginProvider();
    provider.mobileNoOrEmailController.text = 'person@example.com';

    expect(provider.authIdentifier, 'person@example.com');
  });
}
