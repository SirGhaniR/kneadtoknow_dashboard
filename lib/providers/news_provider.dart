import 'dart:io';

import 'package:flutter/material.dart';

import '../models/news.dart';
import '../services/api_service.dart';
import '../utils/app_exception.dart';

class NewsProvider extends ChangeNotifier {
  final List<News> items = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<bool> create({
    required String title,
    required String content,
    required bool isFeatured,
    required File image,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await ApiService.createNews(
        title: title,
        content: content,
        isFeatured: isFeatured,
        image: image,
      );
      await load(page: 1);
      return true;
    } on AppException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = 'An unexpected error occurred';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> delete(int id) async {
    try {
      await ApiService.deleteNews(id);
      final target = items.length == 1 && currentPage > 1
          ? currentPage - 1
          : currentPage;
      await load(page: target);
      return true;
    } on AppException catch (e) {
      error = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      error = 'An unexpected error occurred';
      notifyListeners();
      return false;
    }
  }

  Future<void> load({int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await ApiService.getNewsPage(page: page);
      items
        ..clear()
        ..addAll(result.items);
      currentPage = result.currentPage;
      lastPage = result.lastPage;
    } on AppException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'An unexpected error occurred';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> update({
    required int id,
    required String title,
    required String content,
    required bool isFeatured,
    File? image,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await ApiService.updateNews(
        id: id,
        title: title,
        content: content,
        isFeatured: isFeatured,
        image: image,
      );
      await load(page: currentPage);
      return true;
    } on AppException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = 'An unexpected error occurred';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
