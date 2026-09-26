import 'package:flutter/material.dart';

import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final List<News> items = [];
  int _page = 1;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? error;

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
}
