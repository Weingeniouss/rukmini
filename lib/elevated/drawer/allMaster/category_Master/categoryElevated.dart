// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/all_master/category_master/category_Controller.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../modal/drawer/allMaster/category_Master/categoryList_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CategoryListModal?> getCategoryList() async {
  final CategoryController categoryController = Get.put(CategoryController());
  final http.Response? response = await categoryController.getCategoryList();

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final categoryListModal = CategoryListModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (categoryListModal.status == true) {
          return categoryListModal;
        } else {
          ToastificationError.Error(
              categoryListModal.message ?? AppString.failedToLoadCategoryList);
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
