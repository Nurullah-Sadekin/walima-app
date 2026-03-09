import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_boilerplate/core/constants/app_texts.dart';

/// Singleton Dio client for handling all API calls
/// Includes status code handling and pretty logger
class DioClient {
  factory DioClient() => _instance;

  DioClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppTexts.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          return status != null && status < 500;
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
          // Add authentication token if available
          // final token = await _getAuthToken();
          // if (token != null) {
          //   options.headers['Authorization'] = 'Bearer $token';
          // }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
  // Singleton instance
  static final DioClient _instance = DioClient._internal();

  late Dio _dio;

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
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove authentication token
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
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
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
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
  }) async {
    try {
      final response = await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
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
