import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppErrorReportingService {
  AppErrorReportingService._();

  static final AppErrorReportingService instance = AppErrorReportingService._();

  static const String _telegramChatId = '-5104626422';
  static const String _telegramBotToken = String.fromEnvironment(
    'TELEGRAM_BOT_TOKEN',
    defaultValue: '8271930090:AAFRvxm5jrVeiqGfbVllDIgd9FXtpTpBhIQ',
  );

  final Dio _telegramDio = Dio(
    BaseOptions(
      baseUrl: 'https://api.telegram.org',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: const <String, String>{'Content-Type': 'application/json'},
    ),
  );

  bool _initialized = false;
  Map<String, String> _deviceContext = const <String, String>{};
  String _userId = '';
  String _email = '';
  String _phone = '';

  bool get _supportsCrashlytics => !kIsWeb && Platform.isAndroid;

  Future<void> initialize() async {
    if (_initialized) return;

    _deviceContext = await _buildDeviceContext();

    if (_supportsCrashlytics) {
      final crashlytics = FirebaseCrashlytics.instance;
      await crashlytics.setCrashlyticsCollectionEnabled(true);
      await _applyDeviceContextToCrashlytics(crashlytics);
      await _applyUserContextToCrashlytics(crashlytics);
    }

    _initialized = true;
  }

  Future<void> setUserContext({
    String? userId,
    String? email,
    String? phone,
  }) async {
    _userId = userId?.trim() ?? '';
    _email = email?.trim() ?? '';
    _phone = phone?.trim() ?? '';

    await initialize();
    if (!_supportsCrashlytics) return;

    await _applyUserContextToCrashlytics(FirebaseCrashlytics.instance);
  }

  Future<void> clearUserContext() async {
    _userId = '';
    _email = '';
    _phone = '';

    if (!_supportsCrashlytics) return;

    await FirebaseCrashlytics.instance.setUserIdentifier('');
    await FirebaseCrashlytics.instance.setCustomKey('user_id', '');
    await FirebaseCrashlytics.instance.setCustomKey('user_email', '');
    await FirebaseCrashlytics.instance.setCustomKey('user_phone', '');
  }

  Future<void> recordFlutterFatalError(FlutterErrorDetails details) async {
    await initialize();
    if (!_supportsCrashlytics) return;

    await FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  }

  Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
    Iterable<Object> information = const <Object>[],
  }) async {
    await initialize();
    if (!_supportsCrashlytics) return;

    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
      information: information,
    );
  }

  Future<void> reportApiError(DioException error) async {
    await initialize();

    final request = error.requestOptions;
    final requestSummary =
        '${request.method} ${_truncate(_sanitizeUri(request.uri.toString()), 300)}';
    final statusCode = error.response?.statusCode?.toString() ?? 'N/A';
    final responseBody = _safeJsonEncode(_sanitizeValue(error.response?.data));
    final requestBody = _safeJsonEncode(_sanitizeValue(request.data));
    final query = _safeJsonEncode(_sanitizeValue(request.queryParameters));
    final headers = _safeJsonEncode(_sanitizeHeaders(request.headers));

    await recordError(
      error,
      error.stackTrace,
      reason: 'API error: $requestSummary',
      information: <Object>[
        'status=$statusCode',
        'request=$requestSummary',
        'query=$query',
        'headers=$headers',
        'body=$requestBody',
        'response=$responseBody',
      ],
    );

    await _sendTelegramMessage(
      _buildTelegramApiErrorMessage(
        requestSummary: requestSummary,
        statusCode: statusCode,
        errorType: error.type.name,
        errorMessage: error.message ?? error.error?.toString() ?? 'Unknown',
        query: query,
        headers: headers,
        requestBody: requestBody,
        responseBody: responseBody,
      ),
    );
  }

  Future<void> _applyDeviceContextToCrashlytics(
    FirebaseCrashlytics crashlytics,
  ) async {
    for (final entry in _deviceContext.entries) {
      await crashlytics.setCustomKey(entry.key, entry.value);
    }
  }

  Future<void> _applyUserContextToCrashlytics(
    FirebaseCrashlytics crashlytics,
  ) async {
    await crashlytics.setUserIdentifier(_bestUserIdentifier);
    await crashlytics.setCustomKey('user_id', _userId);
    await crashlytics.setCustomKey('user_email', _email);
    await crashlytics.setCustomKey('user_phone', _phone);
  }

  String get _bestUserIdentifier {
    if (_userId.isNotEmpty) return _userId;
    if (_email.isNotEmpty) return _email;
    if (_phone.isNotEmpty) return _phone;
    return 'anonymous';
  }

  Future<Map<String, String>> _buildDeviceContext() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();
      final context = <String, String>{
        'app_version': packageInfo.version,
        'build_number': packageInfo.buildNumber,
        'platform': defaultTargetPlatform.name,
      };

      if (!kIsWeb && Platform.isAndroid) {
        final info = await deviceInfo.androidInfo;
        context.addAll(<String, String>{
          'device_manufacturer': info.manufacturer.trim(),
          'device_model': info.model.trim(),
          'device_brand': info.brand.trim(),
          'device_android_version': info.version.release.trim(),
          'device_sdk_int': info.version.sdkInt.toString(),
        });
      } else if (!kIsWeb && Platform.isIOS) {
        final info = await deviceInfo.iosInfo;
        context.addAll(<String, String>{
          'device_model': info.utsname.machine.trim(),
          'device_name': info.name.trim(),
          'device_system_name': info.systemName.trim(),
          'device_system_version': info.systemVersion.trim(),
        });
      }

      return context;
    } catch (error) {
      return <String, String>{
        'platform': defaultTargetPlatform.name,
        'device_context_error': error.toString(),
      };
    }
  }

  Future<void> _sendTelegramMessage(String message) async {
    if (_telegramBotToken.trim().isEmpty || _telegramChatId.trim().isEmpty) {
      return;
    }

    try {
      await _telegramDio.post<void>(
        '/bot$_telegramBotToken/sendMessage',
        data: <String, dynamic>{
          'chat_id': _telegramChatId,
          'text': _truncate(message, 3900),
        },
      );
    } catch (_) {
      // Avoid recursive reporting if Telegram itself fails.
    }
  }

  String _buildTelegramApiErrorMessage({
    required String requestSummary,
    required String statusCode,
    required String errorType,
    required String errorMessage,
    required String query,
    required String headers,
    required String requestBody,
    required String responseBody,
  }) {
    final deviceSummary = _deviceContext.entries
        .where((entry) => entry.value.trim().isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');

    return [
      'Walima API Error',
      'Request: $requestSummary',
      'Status: $statusCode',
      'Type: $errorType',
      'Message: ${_truncate(errorMessage, 500)}',
      'User ID: ${_fallbackValue(_userId)}',
      'Email: ${_fallbackValue(_email)}',
      'Phone: ${_fallbackValue(_phone)}',
      if (deviceSummary.isNotEmpty) 'Device:\n$deviceSummary',
      'Query: $query',
      'Headers: $headers',
      'Request Body: ${_truncate(requestBody, 900)}',
      'Response Body: ${_truncate(responseBody, 1200)}',
    ].join('\n\n');
  }

  String _fallbackValue(String value) => value.trim().isEmpty ? 'N/A' : value;

  Object? _sanitizeValue(Object? value) {
    if (value is Map) {
      return value.map<String, dynamic>(
        (key, dynamic item) => MapEntry(
          key.toString(),
          _isSensitiveKey(key.toString()) ? '***' : _sanitizeValue(item),
        ),
      );
    }

    if (value is Iterable) {
      return value.map(_sanitizeValue).toList();
    }

    if (value is String) {
      return _sanitizeString(value);
    }

    return value;
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map<String, dynamic>(
      (key, value) => MapEntry(
        key,
        _isSensitiveKey(key) ? '***' : _sanitizeValue(value),
      ),
    );
  }

  bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase();
    return normalized.contains('authorization') ||
        normalized.contains('password') ||
        normalized.contains('token') ||
        normalized.contains('secret') ||
        normalized.contains('otp');
  }

  String _sanitizeString(String value) {
    if (value.toLowerCase().startsWith('bearer ')) {
      return 'Bearer ***';
    }
    return value;
  }

  String _sanitizeUri(String value) {
    return value.replaceAll(_telegramBotToken, '***');
  }

  String _safeJsonEncode(Object? value) {
    try {
      if (value == null) return 'null';
      if (value is String) return value;
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...';
  }
}
