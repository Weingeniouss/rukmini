import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';

class ProductTypeRemoveController extends GetxController {
  var isLoading = false.obs;

  Future<void> removeProductType({required String productTypeId}) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callProductTypeRemove(productTypeId: productTypeId);
      if (result != null && result.status == true) {
        // Refresh the list in the main controller
        if (Get.isRegistered<ProductTypeController>()) {
          await Get.find<ProductTypeController>().getProductTypeList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('ProductTypeRemove Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
