// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.goldColor, AppColor.dashboardGold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColor.white,
                      fontSize: AppSize.size18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(AppIcon.closeIcon, color: AppColor.white),
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
                      CircularProgressIndicator(color: AppColor.goldColor),
                      SizedBox(height: 10),
                      Text(AppString.fetchingDataPleaseWait),
                    ],
                  ),
                );
              }

              if (uiController.reportList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        AppIcon.infoOutline,
                        size: 50,
                        color: AppColor.goldColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        AppString.noDataFound,
                        style: TextStyle(
                          fontSize: AppSize.size18,
                          color: AppColor.textColor,
                        ),
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
                          headingRowColor: MaterialStateProperty.all(
                            AppColor.whiteOrang.withOpacity(0.5),
                          ),
                          columnSpacing: 20,
                          columns: _buildColumns(index),
                          rows: _buildRows(index, uiController.reportList),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(AppSize.p16),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColor.goldColor, AppColor.dashboardGold],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => uiController.exportReport(index),
                        icon: Icon(AppIcon.download, size: 18),
                        label: const Text(AppString.exportExcel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: AppColor.white,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSize.p24,
                            vertical: AppSize.p12,
                          ),
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
                style: const TextStyle(
                  color: AppColor.goldColor,
                  fontWeight: FontWeight.bold,
                ),
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
        color: AppColor.whiteOrang.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.goldColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _summaryItem(
              AppString.totalGiven,
              uiController.custReportController.totalGivenAmt.value,
            ),
          ),
          Container(
            height: 30,
            width: 1,
            color: AppColor.goldColor.withOpacity(0.2),
          ),
          Expanded(
            child: _summaryItem(
              AppString.totalPending,
              uiController.custReportController.totalPendingAmt.value,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _summaryItem(String label, double amount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSize.size12,
            color: AppColor.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: AppSize.size18,
              fontWeight: FontWeight.bold,
              color: AppColor.goldColor,
            ),
          ),
        ),
      ],
    );
  }

  static List<DataColumn> _buildColumns(int index) {
    if (index == 0) {
      return [
        const DataColumn(label: Text(AppString.code)),
        const DataColumn(label: Text(AppString.name)),
        const DataColumn(label: Text(AppString.phone)),
        const DataColumn(label: Text(AppString.gvnAmt)),
        const DataColumn(label: Text(AppString.pendingAmt)),
        const DataColumn(label: Text(AppString.address)),
      ];
    } else if (index == 1) {
      return [
        const DataColumn(label: Text(AppString.uniqueId)),
        const DataColumn(label: Text(AppString.customer)),
        const DataColumn(label: Text(AppString.phone)),
        const DataColumn(label: Text(AppString.date)),
        const DataColumn(label: Text(AppString.dueDate)),
        const DataColumn(label: Text(AppString.givenAmt)),
        const DataColumn(label: Text(AppString.interest)),
        const DataColumn(label: Text(AppString.balance)),
      ];
    } else {
      return [
        const DataColumn(label: Text(AppString.uniqueId)),
        const DataColumn(label: Text(AppString.customer)),
        const DataColumn(label: Text(AppString.lockerCode)),
        const DataColumn(label: Text(AppString.itemCode)),
        const DataColumn(label: Text(AppString.totalAmt)),
        const DataColumn(label: Text(AppString.balance)),
      ];
    }
  }

  static List<DataRow> _buildRows(int index, List<dynamic> data) {
    return data.map((item) {
      if (index == 0) {
        return DataRow(
          cells: [
            DataCell(Text(item.custCode ?? '')),
            DataCell(Text(item.name ?? '')),
            DataCell(Text(item.custPhone ?? '')),
            DataCell(Text(item.givenAmt?.toString() ?? '')),
            DataCell(Text(item.pendingAmt?.toString() ?? '')),
            DataCell(Text(item.address ?? '')),
          ],
        );
      } else if (index == 1) {
        return DataRow(
          cells: [
            DataCell(Text(item.uniqueId ?? '')),
            DataCell(Text(item.custName ?? '')),
            DataCell(Text(item.custPhone ?? '')),
            DataCell(Text(item.girviDate ?? '')),
            DataCell(Text(item.dueDate ?? '')),
            DataCell(Text(item.givenAmt ?? '')),
            DataCell(Text(item.interest ?? '')),
            DataCell(Text(item.balance ?? '')),
          ],
        );
      } else {
        return DataRow(
          cells: [
            DataCell(Text(item.uniqueId ?? '')),
            DataCell(Text(item.custName ?? '')),
            DataCell(Text(item.lockerCode ?? '')),
            DataCell(Text(item.code ?? '')),
            DataCell(Text(item.totalAmt ?? '')),
            DataCell(Text(item.balance ?? '')),
          ],
        );
      }
    }).toList();
  }
}
