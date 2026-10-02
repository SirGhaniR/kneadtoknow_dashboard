import 'package:dio/dio.dart';

import 'app_exception.dart';

class ErrorHandler {
  static AppException handle(DioException error) {
    if (error.response != null) {
      final statusCode = error.response?.statusCode;
      final data = error.response?.data;

      String message = 'An unexpected error occurred';

      if (data is Map<String, dynamic> && data.containsKey('message')) {
        message = data['message'].toString();
      } else if (data is String) {
        message = data;
      }

      switch (statusCode) {
        case 400:
          return AppException(message, 400);
        case 401:
          return AppException('Session expired. Please log in again.', 401);
        case 403:
          return AppException(
            'You do not have permission to perform this action.',
            403,
          );
        case 404:
          return AppException('The requested resource was not found.', 404);
        case 500:
          return AppException(
            'Internal server error. Please try again later.',
            500,
          );
        default:
          return AppException(message, statusCode);
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const AppException(
          'Connection timed out. Please check your internet.',
        );
      case DioExceptionType.badCertificate:
        return const AppException('Invalid security certificate.');
      case DioExceptionType.connectionError:
        return const AppException('No internet connection.');
      case DioExceptionType.cancel:
        return const AppException('Request was cancelled.');
      default:
        return const AppException('An unexpected network error occurred.');
    }
  }
}
