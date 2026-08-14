// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/category_Controller.dart';

class CategoryAddController extends GetxController {
  var isLoading = false.obs;

  Future<void> addCategory({
    required String name,
    String? categoryId,
  }) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callCategoryAdd(
        name: name,
        categoryId: categoryId,
      );
      if (result != null && result.status == true) {
        // Refresh the list in the main controller
        if (Get.isRegistered<CategoryController>()) {
          await Get.find<CategoryController>().getCategoryList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('CategoryAdd Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
