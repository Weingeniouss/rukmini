import 'dart:convert';
import 'package:http/http.dart' as http;
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
        ToastificationError.Error(model.message ?? 'Failed to remove category');
      }
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
