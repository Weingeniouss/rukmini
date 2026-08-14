// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/product/ProductTypeAdd_service.dart';
import 'package:rukmini/modal/product/productTypeAdd_modal.dart';
import '../../view/utils/widget/pop.dart';

Future<ProductTypeAddModal?> postProductTypeAdd({
  required String name,
  String? productTypeId,
  required String rate,
}) async {
  final ProductTypeAddServices service = ProductTypeAddServices();
  final http.Response response = await service.productTypeAddApi(
    name: name,
    productTypeId: productTypeId,
    rate: rate,
  );

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = ProductTypeAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Success');
        return model;
      } else {
        ToastificationError.Error(
          model.message ?? AppString.failedToAddProductType,
        );
      }
    } else {
      ToastificationError.Error(
        '${AppString.serverError}${response.statusCode}',
      );
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
