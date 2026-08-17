// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/drawer/all_master/category_master/category_service.dart';
import 'package:rukmini/modal/drawer/allMaster/category_Master/categoryList_modal.dart';

class CategoryController extends GetxController {
  final CategoryServices _categoryServices = CategoryServices();
  var isLoading = false.obs;
  var categoryList = <CategoryData>[].obs;
  var categoryData = CategoryListModal().obs;

  Future<http.Response?> getCategoryList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _categoryServices.categoryApi();

      if (kDebugMode) {
        print('Category ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = CategoryListModal.fromJson(decoded);
          categoryData.value = model;
          categoryList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('Category ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
