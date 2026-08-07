import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/productInLocker/cust_product_service.dart';
import 'package:rukmini/modal/drawer/productInLocker/cust_product_model.dart';

class CustProductController extends GetxController {
  final CustProductService _custProductService = CustProductService();
  var isLoading = false.obs;
  var custProductData = CustProductModel().obs;
  var custList = <CustList>[].obs;
  var productList = <ProductList>[].obs;
  var selectedProducts = <ProductList>[].obs;

  void toggleSelection(ProductList item) {
    if (selectedProducts.contains(item)) {
      selectedProducts.remove(item);
    } else {
      selectedProducts.add(item);
    }
  }

  void clearSelection() {
    selectedProducts.clear();
  }

  Future<http.Response?> getCustProduct() async {
    try {
      isLoading.value = true;
      final http.Response response = await _custProductService.custProductApi();

      if (kDebugMode) {
        print('CustProduct Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = CustProductModel.fromJson(decoded);
          custProductData.value = model;
          if (model.data != null) {
            custList.assignAll(model.data?.custList ?? []);
            productList.assignAll(model.data?.productList ?? []);
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustProduct Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
