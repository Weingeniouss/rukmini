// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/product/productType_Controller.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class MetalMasterControllerUI extends GetxController {
  final metalController = TextEditingController();
  final rateController = TextEditingController();
  final editingId = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    metalController.dispose();
    rateController.dispose();
    super.onClose();
  }

  void startEditing(String? id, String? name, String? rate) {
    metalController.text = name ?? "";
    rateController.text = rate ?? "";
    editingId.value = id;
  }

  Future<void> save() async {
    if (metalController.text.isNotEmpty && rateController.text.isNotEmpty) {
      isLoading.value = true;
      final result = await CallApi.callProductTypeAdd(
        name: metalController.text,
        rate: rateController.text,
        productTypeId: editingId.value,
      );
      
      if (result != null && result.status == true) {
        metalController.clear();
        rateController.clear();
        editingId.value = null;
        
        // Refresh the list
        final productTypeController = Get.find<ProductTypeController>();
        await productTypeController.getProductTypeList();
      }
      isLoading.value = false;
    } else {
      ToastificationError.Error(AppString.metalRateError);
    }
  }
}
