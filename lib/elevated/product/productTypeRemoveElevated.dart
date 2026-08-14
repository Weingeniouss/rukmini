// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/product/productTypeRemove_service.dart';
import 'package:rukmini/modal/product/productTypeRemove_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<ProductTypeRemoveModal?> postProductTypeRemove({
  required String productTypeId,
}) async {
  final ProductTypeRemoveServices service = ProductTypeRemoveServices();
  final http.Response response = await service.productTypeRemoveApi(
    productTypeId: productTypeId,
  );

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = ProductTypeRemoveModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Removed successfully');
        return model;
      } else {
        ToastificationError.Error(model.message ?? AppString.failedToRemoveProductType);
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
