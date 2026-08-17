// ignore_for_file: file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/customer_type_master/customerType_Controller.dart';

class CustomerTypeRemoveController extends GetxController {
  var isLoading = false.obs;

  Future<void> removeCustomerType({required String typeId}) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callCustomerTypeRemove(typeId: typeId);
      if (result != null && result.status == true) {
        // Refresh list
        if (Get.isRegistered<CustomerTypeController>()) {
          await Get.find<CustomerTypeController>().getCustomerTypeList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('CustomerTypeRemove ${AppString.errorLog}$e');
    } finally {
      isLoading.value = false;
    }
  }
}
