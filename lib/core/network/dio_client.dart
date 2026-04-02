import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_boilerplate/core/constants/app_texts.dart';
import 'package:flutter_boilerplate/core/global/repositorys/global_repository.dart';
import 'package:flutter_boilerplate/core/network/app_urls.dart';
import 'package:flutter_boilerplate/core/utils/prefs_helper.dart';

/// Singleton Dio client for handling all API calls
/// Includes status code handling and pretty logger
class DioClient {
  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppTexts.baseUrl,
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

    // Add pretty logger interceptor
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

    // Add custom interceptor for token handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final isTokenRequired = options.extra[_isTokenKey] == true;

          if (isTokenRequired) {
            final accessToken = (_authToken?.isNotEmpty ?? false) ? _authToken! : await PrefsHelper.getAccessToken();

            if (accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
            } else {
              options.headers.remove('Authorization');
            }
          } else {
            options.headers.remove('Authorization');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          final statusCode = error.response?.statusCode;
          final requestPath = error.requestOptions.path;
          final isRefreshRequest = requestPath == AppUrls.getAccessToken;
          final isRetried = error.requestOptions.extra[_retryKey] == true;
          final isTokenRequired = error.requestOptions.extra[_isTokenKey] == true;

          if ((statusCode == 403 || statusCode == 401) && isTokenRequired && !isRefreshRequest && !isRetried) {
            final refreshSuccess = await _refreshAccessTokenWithLock();

            if (refreshSuccess) {
              try {
                final response = await _retryRequest(error.requestOptions);
                handler.resolve(response);
                return;
              } catch (_) {
                // If retry fails, fall back to the original error handling.
              }
            }
          }

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

  late Dio _dio;
  Completer<bool>? _refreshCompleter;
  VoidCallback? _onLogout;
  String? _authToken;

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

  Options _optionsWithTokenFlag(Options? options, {required bool isTokenRequired}) {
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
      validateStatus: options?.validateStatus,
      receiveDataWhenStatusError: options?.receiveDataWhenStatusError,
      followRedirects: options?.followRedirects,
      maxRedirects: options?.maxRedirects,
      requestEncoder: options?.requestEncoder,
      responseDecoder: options?.responseDecoder,
      listFormat: options?.listFormat,
    );
  }

  Future<bool> _refreshAccessTokenWithLock() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      bool refreshed = false;
      for (var attempt = 0; attempt < _maxRefreshAttempts; attempt++) {
        refreshed = await GlobalRepository.refreshAccessToken();
        if (refreshed) {
          break;
        }
      }

      if (!refreshed) {
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
    final accessToken = (_authToken?.isNotEmpty ?? false) ? _authToken! : await PrefsHelper.getAccessToken();
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

  Future<void> _logoutUser() async {
    await PrefsHelper.clearTokens();
    removeAuthToken();
    _onLogout?.call();
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
        return ApiResponse.error(
          message: 'Connection timeout. Please try again.',
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
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
        options: _optionsWithTokenFlag(options, isTokenRequired: isTokenRequired),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      return _handleError(e);
    } catch (e) {
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
