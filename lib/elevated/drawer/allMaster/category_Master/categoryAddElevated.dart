// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/services/drawer/all_master/category_master/categoryAdd_service.dart';
import '../../../../modal/drawer/allMaster/category_Master/categoryAdd_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CategoryAddModal?> postCategoryAdd({
  required String name,
  String? categoryId,
}) async {
  final CategoryAddServices service = CategoryAddServices();
  final http.Response response = await service.categoryAddApi(
    name: name,
    categoryId: categoryId,
  );

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = CategoryAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Category details saved successfully');
        return model;
      } else {
        ToastificationError.Error(model.message ?? AppString.failedToAddCategory);
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
