// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';

class LockerRemoveController extends GetxController {
  var isLoading = false.obs;

  Future<void> removeLocker({required String lockerId}) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callLockerRemove(lockerId: lockerId);
      if (result != null && result.status == true) {
        // Refresh list
        if (Get.isRegistered<LockerListController>()) {
          await Get.find<LockerListController>().getLockerList();
        }
      }
    } catch (e) {
      if (kDebugMode) print('LockerRemove Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
