import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kneadtoknow_admin/utils/error_handler.dart';
import 'package:kneadtoknow_admin/utils/app_exception.dart';

void main() {
  group('ErrorHandler', () {
    test('handles 400 Bad Request with message', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 400,
          data: {'message': 'Invalid credentials'},
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(result, isA<AppException>());
      expect(result.message, 'Invalid credentials');
      expect(result.statusCode, 400);
    });

    test('handles 401 Unauthorized', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 401,
          data: {'message': 'Token expired'},
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'Session expired. Please log in again.');
      expect(result.statusCode, 401);
    });

    test('handles 403 Forbidden', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 403,
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(
        result.message,
        'You do not have permission to perform this action.',
      );
      expect(result.statusCode, 403);
    });

    test('handles 404 Not Found', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 404,
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'The requested resource was not found.');
      expect(result.statusCode, 404);
    });

    test('handles 500 Internal Server Error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 500,
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'Internal server error. Please try again later.');
      expect(result.statusCode, 500);
    });

    test('handles unknown server error with string data', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        response: Response(
          requestOptions: RequestOptions(path: '/'),
          statusCode: 418,
          data: 'I am a teapot',
        ),
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'I am a teapot');
      expect(result.statusCode, 418);
    });

    test('handles connection timeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = ErrorHandler.handle(error);

      expect(
        result.message,
        'Connection timed out. Please check your internet.',
      );
      expect(result.statusCode, isNull);
    });

    test('handles receive timeout', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.receiveTimeout,
      );

      final result = ErrorHandler.handle(error);

      expect(
        result.message,
        'Connection timed out. Please check your internet.',
      );
      expect(result.statusCode, isNull);
    });

    test('handles no internet connection', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.connectionError,
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'No internet connection.');
      expect(result.statusCode, isNull);
    });

    test('handles bad certificate', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.badCertificate,
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'Invalid security certificate.');
      expect(result.statusCode, isNull);
    });

    test('handles cancelled request', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.cancel,
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'Request was cancelled.');
      expect(result.statusCode, isNull);
    });

    test('handles completely unknown error', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/'),
        type: DioExceptionType.unknown,
      );

      final result = ErrorHandler.handle(error);

      expect(result.message, 'An unexpected network error occurred.');
      expect(result.statusCode, isNull);
    });
  });
}
