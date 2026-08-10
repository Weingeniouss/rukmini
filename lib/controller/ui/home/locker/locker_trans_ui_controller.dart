import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_trans_controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_wise_del_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_trans_modal.dart';

class LockerTransUIController extends GetxController {
  final lockerTransController = Get.put(LockerTransController());
  final lockerWiseDelController = Get.put(LockerWiseDelController());
  var selectedLocker = Rxn<LockerTransData>();
  var currentPage = 1.obs;
  var searchQuery = "".obs;

  var isSearching = false.obs;
  final searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchLockerTrans();

    // Listen for locker selection changes
    ever(selectedLocker, (LockerTransData? locker) {
      if (locker != null) {
        currentPage.value = 1;
        fetchLockerWiseDetails(locker.lockerId ?? "");
      }
    });

    // Listen for search changes
    debounce(searchQuery, (String query) {
      if (selectedLocker.value != null) {
        currentPage.value = 1;
        fetchLockerWiseDetails(selectedLocker.value!.lockerId ?? "");
      }
    }, time: const Duration(milliseconds: 500));
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchLockerTrans() async {
    await CallApi.callLockerListTrans();
    if (lockerTransController.lockerTransList.isNotEmpty) {
      selectedLocker.value = lockerTransController.lockerTransList.firstWhere(
        (l) => l.isDefault == "1",
        orElse: () => lockerTransController.lockerTransList.first,
      );
    }
  }

  Future<void> fetchLockerWiseDetails(String lockerId) async {
    await CallApi.callLockerWiseDel(
      lockerId: lockerId,
      page: currentPage.value.toString(),
      search: searchQuery.value,
    );
  }

  void selectLocker(LockerTransData locker) {
    selectedLocker.value = locker;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void toggleSearch() {
    isSearching.value = true;
  }

  void closeSearch() {
    isSearching.value = false;
    searchController.clear();
    updateSearch("");
  }
}
