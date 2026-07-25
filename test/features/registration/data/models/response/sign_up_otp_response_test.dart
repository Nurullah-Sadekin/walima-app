import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/features/registration/data/models/response/sign_up_otp_response.dart';

void main() {
  group('SignUpOtpResponse.isAccountExistsError', () {
    test('recognizes an account-exists response message', () {
      final response = SignUpOtpResponse(
        code: 'FAILED',
        message: 'An account already exists for this phone number.',
      );

      expect(response.isAccountExistsError, isTrue);
    });

    test('recognizes an account-exists response code', () {
      final response = SignUpOtpResponse(
        code: 'ACCOUNT_ALREADY_EXISTS',
        message: 'Unable to sign up.',
      );

      expect(response.isAccountExistsError, isTrue);
    });

    test('does not treat other failures as an existing account', () {
      final response = SignUpOtpResponse(
        code: 'INVALID_PHONE_NUMBER',
        message: 'Invalid Bangladeshi mobile number.',
      );

      expect(response.isAccountExistsError, isFalse);
    });

    test('does not mistake a missing account for an existing account', () {
      final response = SignUpOtpResponse(
        code: 'ACCOUNT_NOT_FOUND',
        message: 'This account does not exist.',
      );

      expect(response.isAccountExistsError, isFalse);
    });
  });
}
