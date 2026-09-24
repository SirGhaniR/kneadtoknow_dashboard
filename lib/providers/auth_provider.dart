import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  bool isLoggedIn = false;
  bool isLoading = false;
  String? error;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ApiConfig.tokenKey);
    isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await ApiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConfig.tokenKey, result['token']);
      user = result['user'];
      isLoggedIn = true;
      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiService.logout();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);

    user = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
