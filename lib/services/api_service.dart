import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/dashboard_stats.dart';
import '../models/user.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  ApiService._();

  static Future<DashboardStats> getDashboardStats() async {
    try {
      final res = await _dio.get(ApiConfig.dashboardStats);
      return DashboardStats.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static void init() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString(ApiConfig.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final res = await _dio.post(
        ApiConfig.login,
        data: {'email': email, 'password': password},
      );
      final data = res.data['data'];
      return {'token': data['token'], 'user': User.fromJson(data['user'])};
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<void> logout() async {
    try {
      await _dio.post(ApiConfig.logout);
    } on DioException {
      // silent
    }
  }

  static String parseError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Connection timeout. Check if the server is running.';
      }
      return e.message ?? 'Something went wrong';
    }
    return e.toString();
  }
}
