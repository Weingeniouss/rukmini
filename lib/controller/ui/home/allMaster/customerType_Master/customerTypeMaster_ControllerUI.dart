// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/customer_type_master/customerType_Controller.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class CustomerTypeMasterControllerUI extends GetxController {
  final nameController = TextEditingController();
  final editingId = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  void startEditing(String? id, String? name) {
    nameController.text = name ?? "";
    editingId.value = id;
  }

  Future<void> save() async {
    if (nameController.text.isNotEmpty) {
      isLoading.value = true;
      final result = await CallApi.callCustomerTypeAdd(
        name: nameController.text,
        typeId: editingId.value,
      );
      if (result != null && result.status == true) {
        nameController.clear();
        editingId.value = null;
        // Refresh list
        if (Get.isRegistered<CustomerTypeController>()) {
          await Get.find<CustomerTypeController>().getCustomerTypeList();
        }
      }
      isLoading.value = false;
    } else {
      ToastificationError.Error("Please enter Customer Type");
    }
  }
}
