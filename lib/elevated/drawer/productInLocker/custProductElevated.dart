// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<CustProductModel?> getCustProduct() async {
  final CustProductController custProductController = Get.put(CustProductController());

  final http.Response? response = await custProductController.getCustProduct();

  if (response != null) {
    if (response.statusCode == 200) {
      String body = response.body;
      if (body.contains('{') && body.contains('}')) {
        body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
      }

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final model = CustProductModel.fromJson(decoded);
        if (model.status == false) {
          ToastificationError.Error(model.message ?? 'Failed to load customer products');
        }
        return model;
      }
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
