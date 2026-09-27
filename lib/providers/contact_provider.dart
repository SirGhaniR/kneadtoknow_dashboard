import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../services/api_service.dart';

class ContactProvider extends ChangeNotifier {
  final List<Contact> items = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  String? error;

  Future<bool> delete(int id) async {
    try {
      await ApiService.deleteContact(id);
      final target = items.length == 1 && currentPage > 1
          ? currentPage - 1
          : currentPage;
      await load(page: target);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> load({int page = 1}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final result = await ApiService.getContactPage(page: page);
      items
        ..clear()
        ..addAll(result.items);
      currentPage = result.currentPage;
      lastPage = result.lastPage;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markRead(int id) async {
    try {
      final updated = await ApiService.markContactRead(id);
      final idx = items.indexWhere((c) => c.id == id);
      if (idx != -1) items[idx] = updated;
      notifyListeners();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
