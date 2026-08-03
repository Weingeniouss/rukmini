// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerAdd_Controller.dart';

class LockerMasterControllerUI extends GetxController {
  final _addController = Get.put(LockerAddController());
  final lockerCodeController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final personNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final interestRateController = TextEditingController();

  var isDefaultLocker = false.obs;
  var isLoading = false.obs;
  var editingId = RxnString();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      final data = Get.arguments;
      editingId.value = data.lockerId;
      lockerCodeController.text = data.lockerCode ?? "";
      companyNameController.text = data.comName ?? "";
      companyAddressController.text = data.comAddress ?? "";
      personNameController.text = data.personName ?? "";
      phoneNumberController.text = data.personPhone ?? "";
      interestRateController.text = data.interestRate ?? "";
      isDefaultLocker.value = data.isDefault == "1";
    }
  }

  @override
  void onClose() {
    lockerCodeController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    personNameController.dispose();
    phoneNumberController.dispose();
    interestRateController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    isLoading.value = true;
    final result = await _addController.addLocker(
      lockerCode: lockerCodeController.text,
      comName: companyNameController.text,
      comAddress: companyAddressController.text,
      personName: personNameController.text,
      personPhone: phoneNumberController.text,
      interestRate: interestRateController.text,
      isDefault: isDefaultLocker.value ? "1" : "0",
      lockerId: editingId.value,
    );

    if (result != null && result.status == true) {
      Get.back();
    }
    isLoading.value = false;
  }
}
