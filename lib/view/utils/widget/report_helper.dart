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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Obx(() {
              if (uiController.isReportLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (uiController.reportList.isEmpty) {
                return Center(child: Text(AppString.noDataFound));
              }

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              MaterialStateProperty.all(AppColor.grey200),
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

  static List<DataColumn> _buildColumns(int index) {
    if (index == 0) {
      return [
        const DataColumn(label: Text('Code')),
        const DataColumn(label: Text('Name')),
        const DataColumn(label: Text('Phone')),
        const DataColumn(label: Text('Address')),
      ];
    } else if (index == 1) {
      return [
        const DataColumn(label: Text('Unique ID')),
        const DataColumn(label: Text('Customer')),
        const DataColumn(label: Text('Date')),
        const DataColumn(label: Text('Amt')),
        const DataColumn(label: Text('Bal')),
      ];
    } else {
      return [
        const DataColumn(label: Text('Unique ID')),
        const DataColumn(label: Text('Customer')),
        const DataColumn(label: Text('Code')),
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
          DataCell(Text((item.phoneList != null && item.phoneList.isNotEmpty)
              ? item.phoneList[0].phone ?? ''
              : '')),
          DataCell(Text(item.address ?? '')),
        ]);
      } else if (index == 1) {
        return DataRow(cells: [
          DataCell(Text(item.uniqueId ?? '')),
          DataCell(Text(item.custName ?? '')),
          DataCell(Text(item.girviDate ?? '')),
          DataCell(Text(item.givenAmt ?? '')),
          DataCell(Text(item.balance ?? '')),
        ]);
      } else {
        return DataRow(cells: [
          DataCell(Text(item.uniqueId ?? '')),
          DataCell(Text(item.custName ?? '')),
          DataCell(Text(item.code ?? '')),
          DataCell(Text(item.totalAmt ?? '')),
          DataCell(Text(item.balance ?? '')),
        ]);
      }
    }).toList();
  }
}
