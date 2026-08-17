// ignore_for_file: file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class ChangeLockerControllerUI extends GetxController {
  final lockerListController = Get.put(LockerListController());
  var selectedLocker = Rxn<LockerData>();
  final lockerCodeController = TextEditingController();
  var selectedDate = "".obs;
  DateTime? lockerDate;

  var isLoading = false.obs;

  final Map<String, TextEditingController> tknAmtControllers = {};

  @override
  void onInit() {
    super.onInit();
    lockerListController.getLockerList();
    final custProductController = Get.find<CustProductController>();
    for (var product in custProductController.selectedProducts) {
      tknAmtControllers[product.productId ?? ""] = TextEditingController(
        text: product.balance ?? "0.00",
      );
    }
  }

  @override
  void onClose() {
    lockerCodeController.dispose();
    tknAmtControllers.forEach((key, controller) => controller.dispose());
    super.onClose();
  }

  void selectLocker(LockerData locker) {
    selectedLocker.value = locker;
  }

  void clearLocker() {
    selectedLocker.value = null;
  }

  void selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.primaryColor,
              onPrimary: AppColor.fullScreenColor,
              onSurface: AppColor.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      lockerDate = picked;
      selectedDate.value = DateFormat(
        'dd MMM yyyy',
      ).format(picked).toUpperCase();
    }
  }

  Future<void> submit() async {
    if (selectedLocker.value == null) {
      ToastificationError.Error(AppString.pleaseSelectLocker);
      return;
    }

    if (lockerCodeController.text.isEmpty) {
      ToastificationError.Error(AppString.lockerCodeFieldRequired);
      return;
    }

    if (lockerDate == null) {
      ToastificationError.Error(AppString.pleaseSelectDate);
      return;
    }

    isLoading.value = true;

    final custProductController = Get.find<CustProductController>();
    List<Map<String, String>> lockerProdDelList = [];

    for (var product in custProductController.selectedProducts) {
      lockerProdDelList.add({
        "ProductId": product.productId ?? "",
        "GirviId": product.girviId ?? "",
        "TknAmt": tknAmtControllers[product.productId]?.text ?? "0.00",
      });
    }

    final String lockerProdDel = jsonEncode(lockerProdDelList);

    debugPrint('--- AddProductLocker API ${AppString.bodyLog} ---');
    debugPrint('LockerId: ${selectedLocker.value?.lockerId}');
    debugPrint('InterestRate: ${selectedLocker.value?.interestRate}');
    debugPrint('LockerCode: ${lockerCodeController.text}');
    debugPrint('LockerDate: ${DateFormat('yyyy-MM-dd').format(lockerDate!)}');
    debugPrint('LockerProdDel: $lockerProdDel');
    debugPrint('----------------------------------');

    final result = await CallApi.callAddProductLocker(
      lockerId: selectedLocker.value?.lockerId ?? "",
      interestRate: selectedLocker.value?.interestRate ?? "0.00",
      lockerProdDel: lockerProdDel,
      lockerCode: lockerCodeController.text,
      lockerDate: DateFormat('yyyy-MM-dd').format(lockerDate!),
    );

    if (result != null && result.status == true) {
      custProductController.clearSelection();
      Get.back();
      CallApi.callCustProduct();
    }

    isLoading.value = false;
  }
}
