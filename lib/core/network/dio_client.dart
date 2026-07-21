import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:walima_llc/core/config/app_flavor.dart';
import 'package:walima_llc/core/connectivity/connectivity_keys.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:walima_llc/core/constants/app_texts.dart';
import 'package:walima_llc/core/global/repositorys/global_repository.dart';
import 'package:walima_llc/core/network/app_urls.dart';
import 'package:walima_llc/core/utils/app_error_reporting_service.dart';
import 'package:walima_llc/core/utils/dialog_utils.dart';
import 'package:walima_llc/core/utils/prefs_helper.dart';

/// Singleton Dio client for handling all API calls
/// Includes status code handling and pretty logger
class DioClient {
  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.instance.apiBaseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        // Treat 4xx as errors so token-expiry responses reach onError interceptor
        // where refresh-token retry logic is handled.
        validateStatus: (status) {
          return status != null && status < 400;
        },
      ),
    );

    // Add pretty logger interceptor (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    // Add custom interceptor for token handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isTokenRequired = options.extra[_isTokenKey] == true;
          final requestId = ++_requestCounter;

          options.extra[_requestIdKey] = requestId;
          options.extra[_requestStartAtKey] = DateTime.now().toIso8601String();

          if (isTokenRequired) {
            final accessToken = (_authToken?.isNotEmpty ?? false)
                ? _authToken!
                : await PrefsHelper.getAccessToken();

            if (accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            } else {
              options.headers.remove('Authorization');
            }
          } else {
            options.headers.remove('Authorization');
          }

          _logRequestStart(options, requestId: requestId);

          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(response);
          handler.next(response);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final requestPath = error.requestOptions.path;
          final isRefreshRequest = requestPath == AppUrls.getAccessToken;
          final isRetried = error.requestOptions.extra[_retryKey] == true;
          final isTokenRequired =
              error.requestOptions.extra[_isTokenKey] == true;

          if ((statusCode == 403 || statusCode == 401) &&
              isTokenRequired &&
              !isRefreshRequest &&
              !isRetried) {
            _logRetryStart(error.requestOptions, statusCode: statusCode);
            final refreshSuccess = await _refreshAccessTokenWithLock();

            if (refreshSuccess) {
              try {
                final response = await _retryRequest(error.requestOptions);
                _logRetrySuccess(error.requestOptions);
                handler.resolve(response);
                return;
              } catch (_) {
                // If retry fails, fall back to the original error handling.
              }
            }
          }

          _logError(error);
          unawaited(AppErrorReportingService.instance.reportApiError(error));
          handler.next(error);
        },
      ),
    );
  }
  // Singleton instance
  static final DioClient _instance = DioClient._internal();
  static const int _maxRefreshAttempts = 3;
  static const String _retryKey = 'isRetriedAfterRefresh';
  static const String _isTokenKey = 'isTokenRequired';
  static const String _requestStartAtKey = 'requestStartAt';
  static const String _requestIdKey = 'requestId';

  late Dio _dio;
  Completer<bool>? _refreshCompleter;
  VoidCallback? _onLogout;
  String? _authToken;
  bool _isShowingTimeoutDialog = false;
  int _requestCounter = 0;

  /// Get Dio instance
  Dio get dio => _dio;

  /// Update base URL
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  /// Update headers
  void updateHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Remove authentication token
  void removeAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  /// Optional callback that can navigate to login or show a session-expired UI.
  void setLogoutHandler(VoidCallback onLogout) {
    _onLogout = onLogout;
  }

  Options _optionsWithTokenFlag(
    Options? options, {
    required bool isTokenRequired,
    Set<int>? acceptedStatusCodes,
  }) {
    return Options(
      method: options?.method,
      sendTimeout: options?.sendTimeout,
      receiveTimeout: options?.receiveTimeout,
      extra: {
        ...?options?.extra,
        _isTokenKey: isTokenRequired,
      },
      headers: options?.headers,
      responseType: options?.responseType,
      contentType: options?.contentType,
      receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      followRedirects: options?.followRedirects,
      maxRedirects: options?.maxRedirects,
      requestEncoder: options?.requestEncoder,
      responseDecoder: options?.responseDecoder,
      listFormat: options?.listFormat,
      validateStatus: acceptedStatusCodes == null
          ? options?.validateStatus
          : (status) =>
              status != null && (acceptedStatusCodes.contains(status) || status < 400),
    );
  }

  Future<bool> _refreshAccessTokenWithLock() async {
    if (_refreshCompleter != null) {
      debugPrint('[DioClient] waiting for active refresh-token request');
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      bool refreshed = false;
      for (var attempt = 0; attempt < _maxRefreshAttempts; attempt++) {
        debugPrint(
          '[DioClient] refresh-token attempt ${attempt + 1}/$_maxRefreshAttempts',
        );
        refreshed = await GlobalRepository.refreshAccessToken();
        if (refreshed) {
          debugPrint('[DioClient] refresh-token success');
          break;
        }
      }

      if (!refreshed) {
        debugPrint('[DioClient] refresh-token failed, logging out user');
        await _logoutUser();
      }

      _refreshCompleter!.complete(refreshed);
      return refreshed;
    } catch (_) {
      await _logoutUser();
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final accessToken = (_authToken?.isNotEmpty ?? false)
        ? _authToken!
        : await PrefsHelper.getAccessToken();
    final updatedHeaders = Map<String, dynamic>.from(requestOptions.headers);
    if (accessToken.isNotEmpty) {
      updatedHeaders['Authorization'] = 'Bearer $accessToken';
    } else {
      updatedHeaders.remove('Authorization');
    }

    final options = Options(
      method: requestOptions.method,
      headers: updatedHeaders,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: {
        ...requestOptions.extra,
        _retryKey: true,
        _isTokenKey: true,
      },
      followRedirects: requestOptions.followRedirects,
      listFormat: requestOptions.listFormat,
      maxRedirects: requestOptions.maxRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      receiveTimeout: requestOptions.receiveTimeout,
      validateStatus: requestOptions.validateStatus,
    );

    debugPrint(
      '[DioClient] retrying request #${requestOptions.extra[_requestIdKey]} '
      '${requestOptions.method} ${requestOptions.uri}',
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onSendProgress: requestOptions.onSendProgress,
      onReceiveProgress: requestOptions.onReceiveProgress,
    );
  }

  void _logRequestStart(RequestOptions options, {required int requestId}) {
    debugPrint(
      '[DioClient] --> #$requestId ${options.method} ${options.uri} '
      'tokenRequired=${options.extra[_isTokenKey] == true} '
      'retried=${options.extra[_retryKey] == true} '
      'connectTimeout=${options.connectTimeout?.inMilliseconds ?? _dio.options.connectTimeout?.inMilliseconds}ms '
      'sendTimeout=${options.sendTimeout?.inMilliseconds ?? _dio.options.sendTimeout?.inMilliseconds}ms '
      'receiveTimeout=${options.receiveTimeout?.inMilliseconds ?? _dio.options.receiveTimeout?.inMilliseconds}ms '
      'query=${options.queryParameters}',
    );
  }

  void _logResponse(Response response) {
    final requestId = response.requestOptions.extra[_requestIdKey];
    final startedAt = _parseStartedAt(response.requestOptions);
    final elapsed = startedAt == null
        ? 'unknown'
        : '${DateTime.now().difference(startedAt).inMilliseconds}ms';

    debugPrint(
      '[DioClient] <-- #$requestId ${response.statusCode} '
      '${response.requestOptions.method} ${response.requestOptions.uri} '
      'duration=$elapsed',
    );
  }

  void _logError(DioException error) {
    final requestOptions = error.requestOptions;
    final requestId = requestOptions.extra[_requestIdKey];
    final startedAt = _parseStartedAt(requestOptions);
    final elapsed = startedAt == null
        ? 'unknown'
        : '${DateTime.now().difference(startedAt).inMilliseconds}ms';

    debugPrint(
      '[DioClient] xx #$requestId ${error.type} '
      '${requestOptions.method} ${requestOptions.uri} '
      'duration=$elapsed '
      'status=${error.response?.statusCode} '
      'message=${error.message}',
    );
  }

  void _logRetryStart(RequestOptions requestOptions, {int? statusCode}) {
    debugPrint(
      '[DioClient] auth retry triggered for request #${requestOptions.extra[_requestIdKey]} '
      '${requestOptions.method} ${requestOptions.uri} '
      'status=$statusCode',
    );
  }

  void _logRetrySuccess(RequestOptions requestOptions) {
    debugPrint(
      '[DioClient] auth retry success for request #${requestOptions.extra[_requestIdKey]} '
      '${requestOptions.method} ${requestOptions.uri}',
    );
  }

  DateTime? _parseStartedAt(RequestOptions options) {
    final raw = options.extra[_requestStartAtKey];
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    return null;
  }

  Future<void> _logoutUser() async {
    await PrefsHelper.clearTokens();
    removeAuthToken();
    await AppErrorReportingService.instance.clearUserContext();
    _onLogout?.call();
  }

  Future<void> _showGlobalTimeoutDialog() async {
    if (_isShowingTimeoutDialog) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    _isShowingTimeoutDialog = true;
    try {
      await DialogUtils.showErrorDialog(
        context: context,
        title: 'API Not Responding',
        message:
            'The API is not responding. The request timed out after 60 seconds. Please try again.',
        buttonText: 'OK',
      );
    } finally {
      _isShowingTimeoutDialog = false;
    }
  }

  /// Handle response based on status code
  ApiResponse _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return ApiResponse.success(
          data: response.data,
          message: 'Success',
          statusCode: 200,
        );
      case 201:
        return ApiResponse.success(
          data: response.data,
          message: 'Created successfully',
          statusCode: 201,
        );
      case 204:
        return ApiResponse.success(
          data: null,
          message: 'No content',
          statusCode: 204,
        );
      case 400:
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Bad request',
          statusCode: 400,
          data: response.data,
        );
      case 401:
        return ApiResponse.error(
          message: response.data?['message'] ?? AppTexts.unauthorized,
          statusCode: 401,
          data: response.data,
        );
      case 402:
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Payment required',
          statusCode: 402,
          data: response.data,
        );
      case 403:
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Forbidden',
          statusCode: 403,
          data: response.data,
        );
      case 404:
        return ApiResponse.error(
          message: response.data?['message'] ?? AppTexts.notFound,
          statusCode: 404,
          data: response.data,
        );
      case 422:
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Unprocessable entity',
          statusCode: 422,
          data: response.data,
        );
      case 429:
        return ApiResponse.error(
          message: response.data?['message'] ?? 'Too many requests',
          statusCode: 429,
          data: response.data,
        );
      default:
        return ApiResponse.error(
          message: response.data?['message'] ?? AppTexts.unknownError,
          statusCode: response.statusCode ?? 0,
          data: response.data,
        );
    }
  }

  /// Handle errors
  ApiResponse _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        unawaited(_showGlobalTimeoutDialog());
        return ApiResponse.error(
          message:
              'The API is not responding. The request timed out after 60 seconds.',
          statusCode: 0,
        );
      case DioExceptionType.badResponse:
        if (error.response != null) {
          return _handleResponse(error.response!);
        }
        return ApiResponse.error(
          message: AppTexts.serverError,
          statusCode: 0,
        );
      case DioExceptionType.cancel:
        return ApiResponse.error(
          message: 'Request cancelled',
          statusCode: 0,
        );
      case DioExceptionType.connectionError:
        return ApiResponse.error(
          message: AppTexts.networkError,
          statusCode: 0,
        );
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return ApiResponse.error(
            message: AppTexts.networkError,
            statusCode: 0,
          );
        }
        return ApiResponse.error(
          message: error.message ?? AppTexts.unknownError,
          statusCode: 0,
        );
      default:
        return ApiResponse.error(
          message: AppTexts.unknownError,
          statusCode: 0,
        );
    }
  }

  /// GET request
  Future<ApiResponse> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isTokenRequired = false,
    Set<int>? acceptedStatusCodes,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options:
            _optionsWithTokenFlag(
              options,
              isTokenRequired: isTokenRequired,
              acceptedStatusCodes: acceptedStatusCodes,
            ),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'GET request error for $endpoint',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// POST request
  Future<ApiResponse> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isTokenRequired = false,
    Set<int>? acceptedStatusCodes,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options:
            _optionsWithTokenFlag(
              options,
              isTokenRequired: isTokenRequired,
              acceptedStatusCodes: acceptedStatusCodes,
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'POST request error for $endpoint',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// PUT request
  Future<ApiResponse> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isTokenRequired = false,
    Set<int>? acceptedStatusCodes,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options:
            _optionsWithTokenFlag(
              options,
              isTokenRequired: isTokenRequired,
              acceptedStatusCodes: acceptedStatusCodes,
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'PUT request error for $endpoint',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// PATCH request
  Future<ApiResponse> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool isTokenRequired = false,
    Set<int>? acceptedStatusCodes,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options:
            _optionsWithTokenFlag(
              options,
              isTokenRequired: isTokenRequired,
              acceptedStatusCodes: acceptedStatusCodes,
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'PATCH request error for $endpoint',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// DELETE request
  Future<ApiResponse> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool isTokenRequired = false,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options:
            _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'DELETE request error for $endpoint',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }

  /// Download file
  Future<ApiResponse> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    bool isTokenRequired = false,
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options:
            _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
      unawaited(
        AppErrorReportingService.instance.recordError(
          e,
          StackTrace.current,
          reason: 'DOWNLOAD request error for $urlPath',
        ),
      );
      return ApiResponse.error(
        message: e.toString(),
        statusCode: 0,
      );
    }
  }
}

/// API Response wrapper class
class ApiResponse<T> {
  ApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    required this.statusCode,
  });

  factory ApiResponse.success({
    required T? data,
    required String message,
    required int statusCode,
  }) {
    return ApiResponse(
      isSuccess: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    required int statusCode,
    T? data,
  }) {
    return ApiResponse(
      isSuccess: false,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }
  final bool isSuccess;
  final String message;
  final T? data;
  final int statusCode;

  @override
  String toString() {
    return 'ApiResponse(isSuccess: $isSuccess, message: $message, statusCode: $statusCode, data: $data)';
  }
}
