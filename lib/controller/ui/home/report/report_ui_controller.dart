import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';

class ReportUIController extends GetxController {
  var expandedIndex = (-1).obs;

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  var selectedLocker = "".obs;
  var selectedLockerId = "".obs;

  final lockerListController = Get.put(LockerListController());
  final searchLockerController = TextEditingController();
  var filteredLockers = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    lockerListController.getLockerList();
    ever(lockerListController.lockerList, (list) {
      filteredLockers.assignAll(list);
    });
  }

  void toggleExpansion(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1;
    } else {
      expandedIndex.value = index;
    }
  }

  void updateSearch(String query) {
    if (query.isEmpty) {
      filteredLockers.assignAll(lockerListController.lockerList);
    } else {
      filteredLockers.assignAll(
        lockerListController.lockerList
            .where(
              (l) =>
                  (l.lockerCode?.toLowerCase().contains(query.toLowerCase()) ??
                      false) ||
                  (l.comName?.toLowerCase().contains(query.toLowerCase()) ??
                      false),
            )
            .toList(),
      );
    }
  }

  void selectLocker(dynamic locker) {
    selectedLocker.value = "${locker.lockerCode} (${locker.comName})";
    selectedLockerId.value = locker.lockerId ?? "";
    update();
  }

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }
}
