// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../controller/api/controllers/product/product_Controller.dart';
import '../../modal/product/productList_Modal.dart';
import '../../view/utils/widget/pop.dart';

Future<ProductListModal?> getProductList({
  bool isRefresh = false,
  String? search,
  String? filterType,
}) async {
  final ProductController productController = Get.put(ProductController());
  final http.Response? response = await productController.getProductList(
    isRefresh: isRefresh,
    searchQuery: search,
    filterType: filterType,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final productListModal = ProductListModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (productListModal.status == true) {
          return productListModal;
        } else {
          ToastificationError.Error(
            productListModal.message ?? AppString.failedToLoadProductList,
          );
        }
      } else {
        // ToastificationError.Error(
        //   '${AppString.serverError}${response.statusCode}',
        // );
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
