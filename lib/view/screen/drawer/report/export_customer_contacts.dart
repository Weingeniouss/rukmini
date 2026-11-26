// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/app_color.dart';
import 'package:rukmini/view/utils/app_icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class ExportCustomerContacts extends StatefulWidget {
  final ReportUIController uiController;

  const ExportCustomerContacts({super.key, required this.uiController});

  @override
  State<ExportCustomerContacts> createState() => _ExportCustomerContactsState();
}

class _ExportCustomerContactsState extends State<ExportCustomerContacts> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.uiController.fetchReport(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        back: true,
        title: AppString.exportCustomersContacts,
        centerTitle: true,
      ),
      child: Obx(() {
        if (widget.uiController.isReportLoading.value) {
          return _shimmerLoading();
        }

        if (widget.uiController.reportList.isEmpty) {
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
                    color: AppColor.subText,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildSummary(widget.uiController),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      AppColor.dashboardGold,
                    ),
                    headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.white,
                      fontSize: 13,
                    ),
                    dataRowMinHeight: 48,
                    dataRowMaxHeight: 48,
                    horizontalMargin: 16,
                    columnSpacing: 20,
                    columns: _buildColumns(),
                    rows: _buildRows(widget.uiController.reportList),
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
                  onPressed: () => widget.uiController.exportReport(0),
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text(AppString.exportExcel),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppColor.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: AppSize.p16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummary(ReportUIController uiController) {
    return horizontalPadding(
      child: Container(
        padding: EdgeInsets.all(AppSize.p16),
        margin: EdgeInsets.symmetric(vertical: AppSize.p16),
        decoration: BoxDecoration(
          color: AppColor.cardBg,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColor.border),
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
              color: AppColor.border,
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
            color: AppColor.subText,
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
    return [
      const DataColumn(label: Text(AppString.code)),
      const DataColumn(label: Text(AppString.name)),
      const DataColumn(label: Text(AppString.phone)),
      const DataColumn(label: Text(AppString.gvnAmt)),
      const DataColumn(label: Text(AppString.pendingAmt)),
      const DataColumn(label: Text(AppString.address)),
    ];
  }

  List<DataRow> _buildRows(List<dynamic> data) {
    TextStyle cellTextStyle = TextStyle(color: AppColor.mainText, fontSize: 13);
    return data.map((item) {
      return DataRow(
        cells: [
          DataCell(Text(item.custCode ?? '', style: cellTextStyle)),
          DataCell(Text(item.name ?? '', style: cellTextStyle)),
          DataCell(Text(item.custPhone ?? '', style: cellTextStyle)),
          DataCell(Text(item.givenAmt?.toString() ?? '', style: cellTextStyle)),
          DataCell(Text(item.pendingAmt?.toString() ?? '', style: cellTextStyle)),
          DataCell(Text(item.address ?? '', style: cellTextStyle)),
        ],
      );
    }).toList();
  }

  Widget _shimmerLoading() {
    return Stack(
      children: [
        Column(
          children: [
            Shimmer.fromColors(
              baseColor: AppColor.isDark ? AppColor.shimmerBaseDark : AppColor.grey300,
              highlightColor: AppColor.isDark ? AppColor.shimmerHighlightDark : AppColor.white,
              child: Container(
                height: 80,
                margin: EdgeInsets.all(AppSize.p16),
                decoration: BoxDecoration(
                  color: AppColor.cardBg,
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: AppColor.isDark ? AppColor.shimmerBaseDark : AppColor.grey300,
                highlightColor: AppColor.isDark ? AppColor.shimmerHighlightDark : AppColor.white,
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
                        color: AppColor.cardBg,
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
