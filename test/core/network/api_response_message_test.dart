import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/network/api_response_message.dart';

void main() {
  group('ApiResponseMessage', () {
    test('uses a JSON message', () {
      final message = ApiResponseMessage.extract(
        data: <String, dynamic>{'message': 'The OTP has expired.'},
        contentType: 'application/json',
        statusCode: 400,
      );

      expect(message, 'The OTP has expired.');
    });

    test('finds a nested JSON error', () {
      final message = ApiResponseMessage.extract(
        data: <String, dynamic>{
          'response': <String, dynamic>{
            'errors': <dynamic>[
              <String, dynamic>{'detail': 'Phone number is invalid.'},
            ],
          },
        },
        contentType: 'application/json',
        statusCode: 422,
      );

      expect(message, 'Phone number is invalid.');
    });

    test('decodes a JSON string response', () {
      final message = ApiResponseMessage.extract(
        data: '{"error":"Account is unavailable."}',
        contentType: 'application/json; charset=utf-8',
        statusCode: 403,
      );

      expect(message, 'Account is unavailable.');
    });

    test('extracts a visible heading from HTML', () {
      final message = ApiResponseMessage.extract(
        data: '''
          <!doctype html>
          <html>
            <head><title>Walima</title><script>ignored()</script></head>
            <body><h2>Oops! Page not found.</h2><p>Try again later.</p></body>
          </html>
        ''',
        contentType: 'text/html; charset=utf-8',
        statusCode: 404,
      );

      expect(message, 'Oops! Page not found.');
    });

    test('uses a plain-text response', () {
      final message = ApiResponseMessage.extract(
        data: 'Service is under maintenance.',
        contentType: 'text/plain',
        statusCode: 503,
      );

      expect(message, 'Service is under maintenance.');
    });

    test('falls back to the HTTP reason returned by Dio', () {
      final message = ApiResponseMessage.extract(
        data: null,
        statusCode: 502,
        statusMessage: 'Bad Gateway',
      );

      expect(message, 'Bad Gateway');
    });

    test('normalizes HTML into data legacy repositories can parse', () {
      final data = ApiResponseMessage.normalizeErrorData(
        data: '<html><h1>Not Found</h1></html>',
        message: 'Not Found',
        statusCode: 404,
      );

      expect(
        data,
        <String, dynamic>{
          'code': 'FAILED',
          'message': 'Not Found',
          'statusCode': 404,
        },
      );
    });

    test('preserves JSON fields while adding a top-level message', () {
      final data = ApiResponseMessage.normalizeErrorData(
        data: <String, dynamic>{
          'code': 'E_INVALID_PHONE',
          'errors': <String>['Invalid country code'],
        },
        message: 'Invalid country code',
        statusCode: 422,
      );

      expect(data['code'], 'E_INVALID_PHONE');
      expect(data['errors'], <String>['Invalid country code']);
      expect(data['message'], 'Invalid country code');
      expect(data['statusCode'], 422);
    });
  });
}
