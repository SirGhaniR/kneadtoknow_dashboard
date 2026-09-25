import 'package:flutter/material.dart';

import '../models/dashboard_stats.dart';
import '../services/api_service.dart';

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
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
