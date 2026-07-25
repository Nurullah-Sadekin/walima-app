import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/core/network/dio_client.dart';

void main() {
  AppConfig.initialize();

  late DioClient client;
  late HttpServer server;
  var requestCount = 0;

  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    server.listen((request) async {
      requestCount++;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode(<String, dynamic>{
          'code': 'SUCCESS',
          'message': 'OK',
        }),
      );
      await request.response.close();
    });

    client = DioClient();
    client.updateBaseUrl('http://127.0.0.1:${server.port}');
  });

  setUp(() {
    requestCount = 0;
    client.setAuthToken('test-access-token');
  });

  tearDownAll(() async {
    await server.close(force: true);
  });

  test('blocks authenticated requests after logout', () async {
    client.removeAuthToken();

    final response = await client.get(
      '/protected',
      isTokenRequired: true,
    );

    expect(response.isSuccess, isFalse);
    expect(response.message, 'Request cancelled');
    expect(requestCount, 0);
  });

  test('continues to allow public requests after logout', () async {
    client.removeAuthToken();

    final response = await client.get('/public');

    expect(response.isSuccess, isTrue);
    expect(requestCount, 1);
  });
}
