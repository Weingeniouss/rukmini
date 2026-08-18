import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_wise_del_controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/report/custReport_Controller.dart';
import 'package:rukmini/view/utils/widget/pop.dart';
import 'package:share_plus/share_plus.dart';

class ReportUIController extends GetxController {
  var expandedIndex = (-1).obs;

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  var selectedLocker = "".obs;
  var selectedLockerId = "".obs;

  final lockerListController = Get.put(LockerListController());
  final custReportController = Get.put(CustReportController());
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
      return true;
    } else if (sdkInt >= 30) {
      return true;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> exportReport(int index) async {
    try {
      final hasPermission = await _requestPermissions();
      if (!hasPermission) {
        ToastificationError.Error(
          "Storage permission is required to save files.",
        );
        return;
      }

      await fetchReport(index);

      if (reportList.isEmpty) {
        ToastificationError.Error("No data found to export.");
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      String fileName = "";
      List<String> headers = [];

      if (index == 0) {
        fileName = "Customer_Report.xlsx";
        headers = [
          "Code",
          "Name",
          "Phone",
          "Address",
          "Given Amt",
          "Pending Amt",
        ];
      } else if (index == 1) {
        fileName = "Girvi_Report.xlsx";
        headers = [
          "Unique ID",
          "Customer",
          "Phone",
          "Date",
          "Due Date",
          "Given Amt",
          "Interest",
          "Balance",
        ];
      } else if (index == 2) {
        fileName = "Locker_Report_${selectedLocker.value}.xlsx";
        headers = [
          "Unique ID",
          "Customer",
          "Locker Code",
          "Item Code",
          "Total Amt",
          "Balance",
        ];
      }

      sheetObject.appendRow(headers.map((e) => TextCellValue(e)).toList());

      for (var item in reportList) {
        if (index == 0) {
          sheetObject.appendRow(
            [
              item.custCode ?? '',
              item.name ?? '',
              item.custPhone ?? '',
              item.address ?? '',
              item.givenAmt ?? '',
              item.pendingAmt ?? '',
            ].map((e) => TextCellValue(e.toString())).toList(),
          );
        } else if (index == 1) {
          sheetObject.appendRow(
            [
              item.uniqueId ?? '',
              item.custName ?? '',
              item.custPhone ?? '',
              item.girviDate ?? '',
              item.dueDate ?? '',
              item.givenAmt ?? '',
              item.interest ?? '',
              item.balance ?? '',
            ].map((e) => TextCellValue(e.toString())).toList(),
          );
        } else if (index == 2) {
          sheetObject.appendRow(
            [
              item.uniqueId ?? '',
              item.custName ?? '',
              item.lockerCode ?? '',
              item.code ?? '',
              item.totalAmt ?? '',
              item.balance ?? '',
            ].map((e) => TextCellValue(e.toString())).toList(),
          );
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
      if (isReportLoading.value) return;
      isReportLoading.value = true;
      reportList.clear();

      if (index == 0) {
        // Customer Report
        String fDate = fromDateController.text;
        String tDate = toDateController.text;

        if (fDate.isEmpty) fDate = "2021-01-01";
        if (tDate.isEmpty) {
          tDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        }

        await CallApi.callCustReport(fromDate: fDate, toDate: tDate);
        reportList.assignAll(custReportController.customerReports);
      } else if (index == 1) {
        // Girvi Report
        String fDate = fromDateController.text;
        String tDate = toDateController.text;

        if (fDate.isEmpty) fDate = "2021-01-01";
        if (tDate.isEmpty) {
          tDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        }

        final controller = Get.put(GiriviListController());
        bool hasMore = true;
        int pageCount = 1;

        while (hasMore) {
          final result = await CallApi.callGiriviList(
            isRefresh: pageCount == 1,
            isLoadMoreAction: pageCount > 1,
            formDate: fDate,
            toDate: tDate,
          );

          if (result == null ||
              result.status == false ||
              result.data == null ||
              result.data!.isEmpty ||
              !controller.hasMoreData.value ||
              pageCount > 50) {
            hasMore = false;
          } else {
            pageCount++;
          }
        }
        reportList.assignAll(controller.giriviList);
      } else if (index == 2) {
        // Locker Wise Report
        if (selectedLockerId.isEmpty) {
          ToastificationError.Error("Please select a locker first");
          isReportLoading.value = false;
          return;
        }

        Get.put(LockerWiseDelController());
        final result = await CallApi.callLockerWiseDel(
          lockerId: selectedLockerId.value,
        );
        if (result != null && result.data != null) {
          reportList.assignAll(result.data!);
        }
      }

      // Final Local Filter for Girvi Report
      if (fromDateController.text.isNotEmpty &&
          toDateController.text.isNotEmpty &&
          index == 1) {
        DateTime from = DateTime.parse(fromDateController.text);
        DateTime to = DateTime.parse(
          toDateController.text,
        ).add(const Duration(days: 1));

        reportList.value = reportList.where((item) {
          try {
            DateTime itemDate = DateTime.parse(item.girviDate);
            return itemDate.isAfter(
                  from.subtract(const Duration(seconds: 1)),
                ) &&
                itemDate.isBefore(to);
          } catch (e) {
            return true;
          }
        }).toList();
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
