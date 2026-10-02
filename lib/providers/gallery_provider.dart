import 'dart:io';

import 'package:flutter/material.dart';

import '../models/gallery.dart';
import '../services/api_service.dart';
import '../utils/app_exception.dart';

class GalleryProvider extends ChangeNotifier {
  final List<Gallery> items = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<bool> create({
    required String title,
    required String description,
    required File image,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await ApiService.createGallery(
        title: title,
        description: description,
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
      await ApiService.deleteGallery(id);
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
      final result = await ApiService.getGalleryPage(page: page);
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
    required String description,
    File? image,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      await ApiService.updateGallery(
        id: id,
        title: title,
        description: description,
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
