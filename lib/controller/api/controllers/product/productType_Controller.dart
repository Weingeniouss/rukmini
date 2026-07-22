// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/product/productType_service.dart';
import 'package:rukmini/modal/product/productTypeList_Modal.dart';

class ProductTypeController extends GetxController {
  final ProductTypeServices _productTypeServices = ProductTypeServices();
  var isLoading = false.obs;
  var productTypeList = <ProductTypeData>[].obs;
  var productTypeData = ProductTypeListModal().obs;

  Future<http.Response?> getProductTypeList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _productTypeServices.productTypeApi();

      if (kDebugMode) {
        print('ProductType Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = ProductTypeListModal.fromJson(decoded);
          productTypeData.value = model;
          productTypeList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('ProductType Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
