// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class CategoryMasterControllerUI extends GetxController {
  final categoryController = TextEditingController();
  final editingId = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    categoryController.dispose();
    super.onClose();
  }

  void startEditing(String? id, String? name) {
    categoryController.text = name ?? "";
    editingId.value = id;
  }

  Future<void> save() async {
    if (categoryController.text.isNotEmpty) {
      isLoading.value = true;
      // TODO: Implement Category Add/Update API Call
      // final result = await CallApi.callCategoryAdd(
      //   name: categoryController.text,
      //   categoryId: editingId.value,
      // );
      
      // if (result != null && result.status == true) {
      //   categoryController.clear();
      //   editingId.value = null;
      //   // Refresh the list
      //   final categoryController = Get.find<CategoryController>();
      //   await categoryController.getCategoryList();
      // }
      
      // Temporary logic for UI demo
      await Future.delayed(const Duration(seconds: 1));
      categoryController.clear();
      editingId.value = null;
      
      isLoading.value = false;
    } else {
      ToastificationError.Error("Please enter Product Category");
    }
  }
}
