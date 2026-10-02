import 'package:flutter/material.dart';

import '../models/contact_info.dart';
import '../services/api_service.dart';
import '../utils/app_exception.dart';

class ContactInfoProvider extends ChangeNotifier {
  ContactInfo? info;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<void> load() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      info = await ApiService.getContactInfo();
    } on AppException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'An unexpected error occurred';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> save({
    required String email,
    required String phone,
    required String address,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      info = await ApiService.saveContactInfo(
        email: email,
        phone: phone,
        address: address,
      );
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
