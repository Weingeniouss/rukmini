// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/product/productList_service.dart';
import 'package:rukmini/modal/product/productList_Modal.dart';

class ProductController extends GetxController {
  final ProductListServices _productListServices = ProductListServices();
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;

  var productListData = ProductListModal().obs;
  var products = <ProductListData>[].obs;
  var search = "".obs;

  Future<http.Response?> getProductList({
    bool isRefresh = false,
    String? searchQuery,
  }) async {
    try {
      if (isRefresh) {
        currentPage = 1;
        hasMoreData.value = true;
      }

      if (!hasMoreData.value && !isRefresh) return null;

      if (currentPage == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final http.Response response = await _productListServices.productListApi(
        page: currentPage.toString(),
        search: searchQuery ?? search.value,
      );

      if (kDebugMode) {
        print('ProductList Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = ProductListModal.fromJson(decoded);
          productListData.value = model;

          if (currentPage == 1) {
            products.assignAll(model.data ?? []);
          } else {
            products.addAll(model.data ?? []);
          }

          if (model.data == null || model.data!.isEmpty) {
            hasMoreData.value = false;
          } else {
            currentPage++;
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('ProductList Error: $e');
      return null;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}
