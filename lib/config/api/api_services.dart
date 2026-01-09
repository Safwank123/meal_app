import 'dart:convert' show JsonEncoder;
import 'dart:developer' show log;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import '../constants/url_constants.dart';

class ApiServices {
  final Dio _dio;

  ApiServices()
      : _dio = Dio(
          BaseOptions(
            baseUrl: UrlConstants.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    _addInterceptors();
  }

  void _addInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logRequest(
            options.method,
            options.uri.toString(),
            body: options.data,
            headers: options.headers,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          _logResponse(
            response.requestOptions.method,
            response.requestOptions.uri.toString(),
            response,
          );
          handler.next(response);
        },
        onError: (DioException error, handler) {
          _logError(
            error.type.name,
            error.requestOptions.uri.toString(),
            error,
            error.stackTrace,
          );
          handler.next(error);
        },
      ),
    );
  }
Future<Map<String, dynamic>?> getRequest(
  String path, {
  Map<String, dynamic>? queryParams,
}) async {
  try {
    final response = await _dio.get(
      path,
      queryParameters: queryParams,
    );
    return _handleResponse(response);
  } on DioException catch (e) {
    debugPrint("🌐 Dio error: ${_handleError(e)}");
    return null;
  } catch (e) {
    debugPrint("❌ Unknown error: $e");
    return null;
  }
}

  Future<Map<String, dynamic>?> postRequest(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
   

    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParams,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      return response.data;
    }

    throw DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
    );
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";
      case DioExceptionType.receiveTimeout:
        return "Receive timeout";
      case DioExceptionType.sendTimeout:
        return "Send timeout";
      case DioExceptionType.connectionError:
        return "Connection error";
      case DioExceptionType.cancel:
        return "Request cancelled";
      case DioExceptionType.badResponse:
        return _parseBadResponse(error.response);
      case DioExceptionType.unknown:
      default:
        return "Unexpected error occurred";
    }
  }

  String _parseBadResponse(Response? response) {
    if (response == null) return "Server error";

    final data = response.data;
    if (data is String) return data;

    return data['message'] ??
        data['error'] ??
        "Error: ${response.statusCode}";
  }

  final String _logDivider =
      "--------------------------------------------------";

  void _logRequest(
    String method,
    String url, {
    dynamic body,
    Map<String, dynamic>? headers,
  }) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln(_logDivider)
      ..writeln('API $method REQUEST')
      ..writeln('URL: $url')
      ..writeln('HEADERS: $headers');

    if (body != null) {
      buffer.writeln('BODY: ${_prettyJson(body)}');
    }

    buffer.writeln(_logDivider);
    log(buffer.toString());
  }

  void _logResponse(String method, String url, Response response) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln(_logDivider)
      ..writeln('API $method RESPONSE')
      ..writeln('URL: $url')
      ..writeln('STATUS: ${response.statusCode}')
      ..writeln('RESPONSE: ${_prettyJson(response.data)}')
      ..writeln(_logDivider);

    log(buffer.toString());
  }

  void _logError(
    String method,
    String url,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (!kDebugMode) return;

    final buffer = StringBuffer()
      ..writeln(_logDivider)
      ..writeln('API ERROR')
      ..writeln('URL: $url')
      ..writeln('ERROR: $error');

    if (stackTrace != null) {
      buffer.writeln('STACKTRACE: $stackTrace');
    }

    buffer.writeln(_logDivider);
    log(buffer.toString());
  }

  String _prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }
}
