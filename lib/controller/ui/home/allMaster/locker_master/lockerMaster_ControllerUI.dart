// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/locker_Controller.dart';

class LockerMasterControllerUI extends GetxController {
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
    final result = await CallApi.callLockerAdd(
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
      // Refresh the list
      if (Get.isRegistered<LockerController>()) {
        await Get.find<LockerController>().getLockerList();
      }
      Get.back();
    }
    isLoading.value = false;
  }
}
