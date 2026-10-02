import 'package:flutter/material.dart';

import '../models/dashboard_stats.dart';
import '../services/api_service.dart';
import '../utils/app_exception.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardStats? stats;
  bool isLoading = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      stats = await ApiService.getDashboardStats();
    } on AppException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'An unexpected error occurred';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
