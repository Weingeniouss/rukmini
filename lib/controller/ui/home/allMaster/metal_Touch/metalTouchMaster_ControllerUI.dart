// ignore_for_file: unused_import, file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/metal/metal_Controller.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class MetalTouchMasterControllerUI extends GetxController {
  final karatController = TextEditingController();
  final goldContentController = TextEditingController();
  final editingId = RxnString();
  final isLoading = false.obs;

  @override
  void onClose() {
    karatController.dispose();
    goldContentController.dispose();
    super.onClose();
  }

  void startEditing(String? id, String? karat, String? content) {
    karatController.text = karat ?? "";
    goldContentController.text = content ?? "";
    editingId.value = id;
  }

  Future<void> save() async {
    if (karatController.text.isNotEmpty &&
        goldContentController.text.isNotEmpty) {
      isLoading.value = true;
      final result = await CallApi.callMetalAdd(
        karat: karatController.text,
        goldContent: goldContentController.text,
        metalId: editingId.value,
      );

      if (result != null && result.status == true) {
        karatController.clear();
        goldContentController.clear();
        editingId.value = null;

        final controller = Get.find<MetalController>();
        await controller.getMetalList();
      }

      isLoading.value = false;
    } else {
      ToastificationError.Error("Please enter Karat and Gold Content");
    }
  }
}
