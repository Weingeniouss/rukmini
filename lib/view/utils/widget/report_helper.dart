// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';

class ReportHelper {
  static void showReportDialog({
    required BuildContext context,
    required ReportUIController uiController,
    required int index,
    required String title,
  }) {
    uiController.fetchReport(index);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Container(
            padding: EdgeInsets.all(AppSize.p16),
            decoration: BoxDecoration(
              color: AppColor.activeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColor.white,
                    fontSize: AppSize.size18,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColor.white),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Obx(() {
              if (uiController.isReportLoading.value) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text("Fetching data, please wait..."),
                    ],
                  ),
                );
              }

              if (uiController.reportList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 50, color: AppColor.textColor),
                      const SizedBox(height: 10),
                      Text(
                        AppString.noDataFound,
                        style: TextStyle(fontSize: AppSize.size18, color: AppColor.textColor),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  if (index == 0) _buildSummary(uiController),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(AppColor.grey200),
                          columnSpacing: 20,
                          columns: _buildColumns(index),
                          rows: _buildRows(index, uiController.reportList),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSize.p16),
                    child: ElevatedButton.icon(
                      onPressed: () => uiController.exportReport(index),
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text("Export Excel"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.activeColor,
                        foregroundColor: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.p24,
                          vertical: AppSize.p8,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppString.ok,
                style: TextStyle(color: AppColor.activeColor),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildSummary(ReportUIController uiController) {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      margin: EdgeInsets.all(AppSize.p8),
      decoration: BoxDecoration(
        color: AppColor.lightBlue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem("Total Given", uiController.custReportController.totalGivenAmt.value),
          _summaryItem("Total Pending", uiController.custReportController.totalPendingAmt.value),
        ],
      ),
    );
  }

  static Widget _summaryItem(String label, double amount) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: AppSize.size14, color: AppColor.textColor)),
        Text("₹${amount.toStringAsFixed(2)}", 
            style: TextStyle(fontSize: AppSize.size18, fontWeight: FontWeight.bold, color: AppColor.primaryColor)),
      ],
    );
  }

  static List<DataColumn> _buildColumns(int index) {
    if (index == 0) {
      return [
        const DataColumn(label: Text('Code')),
        const DataColumn(label: Text('Name')),
        const DataColumn(label: Text('Phone')),
        const DataColumn(label: Text('Given Amt')),
        const DataColumn(label: Text('Pending Amt')),
        const DataColumn(label: Text('Address')),
      ];
    } else if (index == 1) {
      return [
        const DataColumn(label: Text('Unique ID')),
        const DataColumn(label: Text('Customer')),
        const DataColumn(label: Text('Phone')),
        const DataColumn(label: Text('Date')),
        const DataColumn(label: Text('Due Date')),
        const DataColumn(label: Text('Given Amt')),
        const DataColumn(label: Text('Interest')),
        const DataColumn(label: Text('Balance')),
      ];
    } else {
      return [
        const DataColumn(label: Text('Unique ID')),
        const DataColumn(label: Text('Customer')),
        const DataColumn(label: Text('Locker Code')),
        const DataColumn(label: Text('Item Code')),
        const DataColumn(label: Text('Total Amt')),
        const DataColumn(label: Text('Balance')),
      ];
    }
  }

  static List<DataRow> _buildRows(int index, List<dynamic> data) {
    return data.map((item) {
      if (index == 0) {
        return DataRow(cells: [
          DataCell(Text(item.custCode ?? '')),
          DataCell(Text(item.name ?? '')),
          DataCell(Text(item.custPhone ?? '')),
          DataCell(Text(item.givenAmt?.toString() ?? '')),
          DataCell(Text(item.pendingAmt?.toString() ?? '')),
          DataCell(Text(item.address ?? '')),
        ]);
      } else if (index == 1) {
        return DataRow(cells: [
          DataCell(Text(item.uniqueId ?? '')),
          DataCell(Text(item.custName ?? '')),
          DataCell(Text(item.custPhone ?? '')),
          DataCell(Text(item.girviDate ?? '')),
          DataCell(Text(item.dueDate ?? '')),
          DataCell(Text(item.givenAmt ?? '')),
          DataCell(Text(item.interest ?? '')),
          DataCell(Text(item.balance ?? '')),
        ]);
      } else {
        return DataRow(cells: [
          DataCell(Text(item.uniqueId ?? '')),
          DataCell(Text(item.custName ?? '')),
          DataCell(Text(item.lockerCode ?? '')),
          DataCell(Text(item.code ?? '')),
          DataCell(Text(item.totalAmt ?? '')),
          DataCell(Text(item.balance ?? '')),
        ]);
      }
    }).toList();
  }
}
