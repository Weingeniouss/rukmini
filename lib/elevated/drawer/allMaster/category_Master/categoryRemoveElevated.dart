// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/services/drawer/all_master/category_master/categoryRemove_service.dart';
import '../../../../modal/drawer/allMaster/category_Master/categoryRemove_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CategoryRemoveModal?> postCategoryRemove({required String categoryId}) async {
  final CategoryRemoveServices service = CategoryRemoveServices();
  final http.Response response = await service.categoryRemoveApi(categoryId: categoryId);

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = CategoryRemoveModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Category removed successfully');
        return model;
      } else {
        ToastificationError.Error(model.message ?? AppString.failedToRemoveCategory);
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
