import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import 'package:rukmini/view/utils/widget/pop.dart';
import 'package:share_plus/share_plus.dart';

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

  Future<bool> _requestPermissions() async {
    if (!Platform.isAndroid) return true;

    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13+ (API 33) doesn't need WRITE_EXTERNAL_STORAGE for temp files or sharing
      // Photos/Videos/Audio permissions are not needed for Excel docs
      return true;
    } else if (sdkInt >= 30) {
      // Android 11 & 12 (API 30-32) use Scoped Storage
      // Writing to temp directory is always allowed
      return true;
    } else {
      // Android 10 and below (API < 30)
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> exportReport(int index) async {
    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        ToastificationError.Error("Storage permission is required to save files.");
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      String fileName = "";
      List<String> headers = [];

      if (index == 0) {
        fileName = "Customer_Report.xlsx";
        headers = ["Name", "Cust Code", "Gvn Amt", "Pending Amt", "Phone"];
      } else if (index == 1) {
        fileName = "Girvi_Report.xlsx";
        headers = ["Unique ID", "Customer", "Date", "Given Amt", "Balance"];
      } else if (index == 2) {
        if (selectedLockerId.isEmpty) {
          ToastificationError.Error("Please select a locker first");
          return;
        }
        fileName = "Locker_Report_${selectedLocker.value}.xlsx";
        headers = ["Unique ID", "Weight", "Category", "Metal", "Date"];
      }

      sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

      // Add actual data
      await fetchReport(index);
      for (var item in reportList) {
        if (index == 0) {
          sheetObject.appendRow([
            item.name ?? '',
            item.custCode ?? '',
            item.gracePeriod ?? '',
            '',
            (item.phoneList != null && item.phoneList.isNotEmpty) ? item.phoneList[0].phone ?? '' : ''
          ].map((e) => TextCellValue(e.toString())).toList());
        } else if (index == 1) {
          sheetObject.appendRow([
            item.uniqueId ?? '',
            item.custName ?? '',
            item.girviDate ?? '',
            item.givenAmt ?? '',
            item.balance ?? ''
          ].map((e) => TextCellValue(e.toString())).toList());
        } else if (index == 2) {
          sheetObject.appendRow([
            item.uniqueId ?? '',
            '',
            '',
            '',
            item.code ?? ''
          ].map((e) => TextCellValue(e.toString())).toList());
        }
      }

      var fileBytes = excel.save();
      if (fileBytes == null) return;

      final directory = await getTemporaryDirectory();
      final path = "${directory.path}/$fileName";
      final file = File(path);
      await file.writeAsBytes(fileBytes);

      await Share.shareXFiles([XFile(path)], text: 'Exported $fileName');
    } catch (e) {
      ToastificationError.Error("Export Failed: ${e.toString()}");
    }
  }

  var reportList = <dynamic>[].obs;
  var isReportLoading = false.obs;

  Future<void> fetchReport(int index) async {
    try {
      isReportLoading.value = true;
      reportList.clear();

      if (index == 0) {
        await CallApi.callCustList(isRefresh: true);
        final controller = Get.find<CustListController>();
        reportList.assignAll(controller.customers);
      } else if (index == 1) {
        final result = await CallApi.callGiriviList(
          isRefresh: true,
          formDate: fromDateController.text,
          toDate: toDateController.text,
        );
        if (result != null && result.data != null) {
          reportList.assignAll(result.data!);
        }
      } else if (index == 2) {
        if (selectedLockerId.isEmpty) {
          ToastificationError.Error("Please select a locker first");
          isReportLoading.value = false;
          return;
        }
        final result = await CallApi.callLockerWiseDel(
          lockerId: selectedLockerId.value,
        );
        if (result != null && result.data != null) {
          reportList.assignAll(result.data!);
        }
      }
    } catch (e) {
      ToastificationError.Error("Failed to fetch report: $e");
    } finally {
      isReportLoading.value = false;
    }
  }

  @override
  void onClose() {
    fromDateController.dispose();
    toDateController.dispose();
    searchLockerController.dispose();
    super.onClose();
  }
}
