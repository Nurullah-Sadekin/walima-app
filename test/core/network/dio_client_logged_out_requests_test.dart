import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/core/network/dio_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppConfig.initialize();

  late DioClient client;
  late _RecordingAdapter adapter;

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    client = DioClient();
    client.updateBaseUrl('https://example.test');
    adapter = _RecordingAdapter();
    client.dio.httpClientAdapter = adapter;
  });

  setUp(() {
    adapter.reset();
    client.setAuthToken('test-access-token');
  });

  test('allows requests without an Authorization header after logout',
      () async {
    client.removeAuthToken();

    final response = await client.get(
      '/public-but-legacy-token-flagged',
      isTokenRequired: true,
    );

    expect(response.isSuccess, isTrue);
    expect(adapter.requestCount, 1);
    expect(adapter.authorizationHeader, isNull);
  });

  test('continues to allow explicitly public requests after logout', () async {
    client.removeAuthToken();

    final response = await client.get('/public');

    expect(response.isSuccess, isTrue);
    expect(adapter.requestCount, 1);
    expect(adapter.authorizationHeader, isNull);
  });
}

class _RecordingAdapter implements HttpClientAdapter {
  int requestCount = 0;
  String? authorizationHeader;

  void reset() {
    requestCount = 0;
    authorizationHeader = null;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requestCount++;
    authorizationHeader = options.headers['Authorization']?.toString();
    return ResponseBody.fromString(
      '{"code":"SUCCESS","message":"OK"}',
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
