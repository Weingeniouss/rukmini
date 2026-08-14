// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_add_modal.dart';

class LockerAddController extends GetxController {
  var isLoading = false.obs;

  Future<LockerAddModal?> addLocker({
    required String lockerCode,
    required String comName,
    required String comAddress,
    required String personName,
    required String personPhone,
    required String interestRate,
    required String isDefault,
    String? lockerId,
  }) async {
    try {
      isLoading.value = true;
      final result = await CallApi.callLockerAdd(
        lockerCode: lockerCode,
        comName: comName,
        comAddress: comAddress,
        personName: personName,
        personPhone: personPhone,
        interestRate: interestRate,
        isDefault: isDefault,
        lockerId: lockerId,
      );

      if (result != null && result.status == true) {
        // Refresh the list
        if (Get.isRegistered<LockerListController>()) {
          await Get.find<LockerListController>().getLockerList();
        }
      }
      return result;
    } catch (e) {
      if (kDebugMode) print('LockerAdd Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
