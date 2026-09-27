import 'package:flutter/material.dart';

import '../models/contact_info.dart';
import '../services/api_service.dart';

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
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
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
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }
}
