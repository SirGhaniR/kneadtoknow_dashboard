import 'dart:io';

import 'package:flutter/material.dart';

import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final List<News> items = [];
  int _page = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isSaving = false;
  bool hasMore = true;
  String? error;

  Future<bool> create({
    required String title,
    required String content,
    required bool isFeatured,
    required File image,
  }) async {
    isSaving = true;
    notifyListeners();
    try {
      await ApiService.createNews(
        title: title,
        content: content,
        isFeatured: isFeatured,
        image: image,
      );
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> delete(int id) async {
    try {
      await ApiService.deleteNews(id);
      items.removeWhere((n) => n.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> load() async {
    isLoading = true;
    error = null;
    _page = 1;
    hasMore = true;
    notifyListeners();

    try {
      final result = await ApiService.getNews(page: 1);
      items
        ..clear()
        ..addAll(result);
      hasMore = result.length >= 10;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();

    try {
      final next = _page + 1;
      final result = await ApiService.getNews(page: next);
      if (result.isEmpty) {
        hasMore = false;
      } else {
        items.addAll(result);
        _page = next;
        hasMore = result.length >= 10;
      }
    } catch (_) {
      hasMore = false;
    } finally {
      isLoadingMore = false;
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
    notifyListeners();
    try {
      await ApiService.updateNews(
        id: id,
        title: title,
        content: content,
        isFeatured: isFeatured,
        image: image,
      );
      await load();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
