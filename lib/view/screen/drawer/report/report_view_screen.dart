// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class ReportViewScreen extends StatefulWidget {
  const ReportViewScreen({super.key});

  @override
  State<ReportViewScreen> createState() => _ReportViewScreenState();
}

class _ReportViewScreenState extends State<ReportViewScreen> {
  late final ReportUIController uiController;
  late final int index;
  late final String title;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    index = args['index'];
    title = args['title'];
    uiController = Get.find<ReportUIController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      uiController.fetchReport(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(back: true, title: title, centerTitle: true),
      child: Obx(() {
        if (uiController.isReportLoading.value) {
          return _shimmerLoading();
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
            if (index == 0) _buildSummary(),
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
                    columns: _buildColumns(),
                    rows: _buildRows(uiController.reportList),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSize.p16),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.goldColor, AppColor.dashboardGold],
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummary() {
    return horizontalPadding(
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
        margin: EdgeInsets.symmetric(vertical: AppSize.p16),
        decoration: BoxDecoration(
          color: AppColor.whiteOrang.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
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
      ),
    );
  }

  Widget _summaryItem(String label, double amount) {
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

  List<DataColumn> _buildColumns() {
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

  List<DataRow> _buildRows(List<dynamic> data) {
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

  Widget _shimmerLoading() {
    return Stack(
      children: [
        Column(
          children: [
            if (index == 0)
              Shimmer.fromColors(
                baseColor: AppColor.grey300.withOpacity(0.5),
                highlightColor: AppColor.white,
                child: Container(
                  height: 80,
                  margin: EdgeInsets.all(AppSize.p16),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: AppColor.grey300.withOpacity(0.5),
                highlightColor: AppColor.white,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                        horizontal: AppSize.p16,
                        vertical: AppSize.p8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const Center(
          child: CircularProgressIndicator(color: AppColor.goldColor),
        ),
      ],
    );
  }
}
