import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/network/api_envelope.dart';

void main() {
  test('decodes the handler payload only from response', () {
    final envelope = ApiEnvelope<Map<String, dynamic>>.fromJson(
      <String, dynamic>{
        'code': 'SUCCESS',
        'message': 'ok',
        'response': <String, dynamic>{'data': <dynamic>[]},
        'traceId': 'trace-123',
        'data': <dynamic>['wrong-level'],
      },
      (json) => json,
    );

    expect(envelope.isSuccess, isTrue);
    expect(envelope.response['data'], isEmpty);
    expect(envelope.traceId, 'trace-123');
  });

  test('rejects a missing response payload', () {
    expect(
      () => ApiEnvelope<Map<String, dynamic>>.fromJson(
        <String, dynamic>{'code': 'SUCCESS'},
        (json) => json,
      ),
      throwsFormatException,
    );
  });
}
