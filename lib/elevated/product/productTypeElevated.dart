// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../controller/api/controllers/product/productType_Controller.dart';
import '../../modal/product/productTypeList_Modal.dart';
import '../../view/utils/widget/pop.dart';

Future<ProductTypeListModal?> getProductTypeList() async {
  final ProductTypeController productTypeController = Get.put(ProductTypeController());
  final http.Response? response = await productTypeController.getProductTypeList();

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final productTypeListModal = ProductTypeListModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (productTypeListModal.status == true) {
          return productTypeListModal;
        } else {
          ToastificationError.Error(
              productTypeListModal.message ?? AppString.failedToLoadProductTypeList);
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
