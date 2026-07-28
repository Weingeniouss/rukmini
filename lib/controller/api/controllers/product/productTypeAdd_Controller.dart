// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';

class ProductTypeAddController extends GetxController {
  var isLoading = false.obs;

  Future<void> addProductType({
    required String name,
    required String rate,
    String? productTypeId,
  }) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callProductTypeAdd(
        name: name,
        rate: rate,
        productTypeId: productTypeId,
      );
      if (result != null && result.status == true) {
        // Refresh the list in the other controller
        final productTypeController = Get.find<ProductTypeController>();
        await productTypeController.getProductTypeList();
      }
    } catch (e) {
      if (kDebugMode) print('AddProductType Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
