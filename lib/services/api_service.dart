import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/dashboard_stats.dart';
import '../models/gallery.dart';
import '../models/news.dart';
import '../models/user.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
    ),
  );

  ApiService._();

  static Future<Gallery> createGallery({
    required String title,
    required String description,
    required File image,
  }) async {
    try {
      final form = FormData.fromMap({
        'title': title,
        'description': description,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      final res = await _dio.post(ApiConfig.gallery, data: form);
      return Gallery.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<News> createNews({
    required String title,
    required String content,
    required bool isFeatured,
    required File image,
  }) async {
    try {
      final form = FormData.fromMap({
        'title': title,
        'content': content,
        'is_featured': isFeatured ? 1 : 0,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      final res = await _dio.post(ApiConfig.news, data: form);
      return News.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<void> deleteGallery(int id) async {
    try {
      await _dio.delete('${ApiConfig.gallery}/$id');
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<void> deleteNews(int id) async {
    try {
      await _dio.delete('${ApiConfig.news}/$id');
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<DashboardStats> getDashboardStats() async {
    try {
      final res = await _dio.get(ApiConfig.dashboardStats);
      return DashboardStats.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<GalleryPage> getGalleryPage({int page = 1}) async {
    try {
      final res = await _dio.get(
        ApiConfig.gallery,
        queryParameters: {'page': page, 'per_page': 12},
      );
      final list = res.data['data'] as List;
      final meta = res.data['meta'] as Map? ?? {};
      return GalleryPage(
        items: list.map((e) => Gallery.fromJson(e)).toList(),
        currentPage: meta['current_page'] ?? 1,
        lastPage: meta['last_page'] ?? 1,
      );
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<NewsPage> getNewsPage({int page = 1}) async {
    try {
      final res = await _dio.get(
        ApiConfig.news,
        queryParameters: {'page': page, 'per_page': 10},
      );
      final list = res.data['data'] as List;
      final meta = res.data['meta'] as Map? ?? {};
      return NewsPage(
        items: list.map((e) => News.fromJson(e)).toList(),
        currentPage: meta['current_page'] ?? 1,
        lastPage: meta['last_page'] ?? 1,
      );
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
      if (data is Map) {
        if (data['errors'] is Map) {
          final errors = data['errors'] as Map;
          if (errors.isNotEmpty) {
            final first = errors.values.first;
            if (first is List && first.isNotEmpty) {
              return first.first.toString();
            }
          }
        }
        if (data['message'] != null) return data['message'].toString();
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        return 'Connection timeout. Check if the server is running.';
      }
      return e.message ?? 'Something went wrong';
    }
    return e.toString();
  }

  static Future<Gallery> updateGallery({
    required int id,
    required String title,
    required String description,
    File? image,
  }) async {
    try {
      final fields = <String, dynamic>{
        'title': title,
        'description': description,
      };
      if (image != null) {
        fields['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }
      final form = FormData.fromMap(fields);
      final res = await _dio.put('${ApiConfig.gallery}/$id', data: form);
      return Gallery.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }

  static Future<News> updateNews({
    required int id,
    required String title,
    required String content,
    required bool isFeatured,
    File? image,
  }) async {
    try {
      final fields = <String, dynamic>{
        'title': title,
        'content': content,
        'is_featured': isFeatured ? 1 : 0,
      };
      if (image != null) {
        fields['image'] = await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        );
      }
      final form = FormData.fromMap(fields);
      final res = await _dio.put('${ApiConfig.news}/$id', data: form);
      return News.fromJson(res.data['data']);
    } on DioException catch (e) {
      throw Exception(parseError(e));
    }
  }
}

class GalleryPage {
  final List<Gallery> items;
  final int currentPage;
  final int lastPage;

  GalleryPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });
}

class NewsPage {
  final List<News> items;
  final int currentPage;
  final int lastPage;

  NewsPage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });
}
