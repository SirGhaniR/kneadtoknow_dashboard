import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../utils/app_exception.dart';

class AuthProvider extends ChangeNotifier {
  User? user;
  bool isLoggedIn = false;
  bool isLoading = false;
  String? error;

  Future<void> expireSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(ApiConfig.tokenKey);
    user = null;
    isLoggedIn = false;
    notifyListeners();
  }

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
      return true;
    } on AppException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
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
