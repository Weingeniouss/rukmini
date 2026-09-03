// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/routes/app_pages.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class Reports extends StatelessWidget {
  final ReportUIController uiController;

  const Reports({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Fullscreen(
          isPadding: false,
          backGroundcolor: AppColor.backgroundColor,
          drawer: homeDrawer(),
          appBar: appBar(
            centerTitle: true,
            back: false,
            title: _buildDecorativeTitle(AppString.reports),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: AppSize.p12),
            child: Column(
              children: [
                _buildReportCard(
                  context: context,
                  index: 0,
                  title: AppString.customerReport,
                  icon: AppIcon.person,
                  child: _buildDateRangeFilter(context),
                ),
                _buildReportCard(
                  context: context,
                  index: 1,
                  title: AppString.girviReport,
                  icon: AppIcon.grid,
                  child: _buildDateRangeFilter(context),
                ),
                _buildReportCard(
                  context: context,
                  index: 2,
                  title: AppString.lockerWiseReport,
                  icon: AppIcon.locker,
                  child: Column(
                    children: [
                      _buildLockerFilter(context),
                      SizedBox(height: AppSize.p8),
                      _buildDateRangeFilter(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(() {
          if (uiController.isReportLoading.value) {
            return Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: AppColor.goldColor),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDecorativeTitle(String title) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.black,
            fontSize: AppSize.titleText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: AppSize.p4 / 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.p40,
              height: AppSize.p4 / 4,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p4),
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: AppSize.p4 * 1.5,
                  height: AppSize.p4 * 1.5,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: AppSize.p40,
              height: AppSize.p4 / 4,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required int index,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return horizontalPadding(
      child: Obx(() {
        bool isExpanded = uiController.expandedIndex.value == index;
        return Container(
          margin: EdgeInsets.only(bottom: AppSize.p16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p12),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.05),
                blurRadius: AppSize.p10,
                offset: Offset(0, AppSize.p4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.p12),
            child: Column(
              children: [
                _buildCardHeader(title, icon, index, isExpanded),
                if (isExpanded) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSize.p12),
                      bottomRight: Radius.circular(AppSize.p12),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -AppSize.p20,
                          right: -AppSize.p20,
                          child: Icon(
                            AppIcon.leaf,
                            color: AppColor.goldColor.withOpacity(0.05),
                            size: AppSize.iconLarge * 3,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(AppSize.p16),
                          child: Column(
                            children: [
                              child,
                              if (index == 0) ...[
                                SizedBox(height: AppSize.p16),
                                _buildCustomerSummary(),
                              ],
                              SizedBox(height: AppSize.p20),
                              _buildCardActions(context, index, title),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCardHeader(
    String title,
    IconData icon,
    int index,
    bool isExpanded,
  ) {
    return IntrinsicHeight(
      child: InkWell(
        onTap: () => uiController.toggleExpansion(index),
        child: Row(
          children: [
            // Left gold indicator
            Container(width: AppSize.p4, color: AppColor.goldColor),
            Padding(
              padding: EdgeInsets.all(AppSize.p12),
              child: Row(
                children: [
                  // Icon container
                  Container(
                    padding: EdgeInsets.all(AppSize.p10),
                    decoration: BoxDecoration(
                      color: AppColor.whiteOrang.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: AppColor.goldColor,
                      size: AppSize.p24,
                    ),
                  ),
                  SizedBox(width: AppSize.p12),
                  // Vertical divider
                  Container(
                    width: AppSize.p4 / 4,
                    height: AppSize.p24,
                    color: AppColor.grey300.withOpacity(0.5),
                  ),
                ],
              ),
            ),
            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColor.black,
                  fontSize: AppSize.commonText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Right arrow
            Padding(
              padding: EdgeInsets.only(right: AppSize.p16),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isExpanded ? 0.25 : 0,
                // 90 degrees rotation when expanded
                child: Icon(
                  AppIcon.rightArrow,
                  color: AppColor.goldColor,
                  size: AppSize.p20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardActions(BuildContext context, int index, String title) {
    return Row(
      children: [
        Expanded(
          child: _gradientButton(
            text: "Export Excel",
            icon: AppIcon.download,
            onPressed: () => uiController.exportReport(index),
          ),
        ),
        SizedBox(width: AppSize.p12),
        Expanded(
          child: _gradientButton(
            text: AppString.viewReport,
            onPressed: () {
              if (index == 0) {
                Get.toNamed(Routes.exportContacts);
              } else {
                Get.toNamed(Routes.reportView, arguments: {
                  'index': index,
                  'title': title,
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _gradientButton({
    required String text,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.goldColor, AppColor.dashboardGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.goldColor.withOpacity(0.3),
            blurRadius: AppSize.p4,
            offset: Offset(0, AppSize.p4 / 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.transparent,
          shadowColor: AppColor.transparent,
          padding: EdgeInsets.symmetric(vertical: AppSize.p12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.p12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppColor.white, size: AppSize.p16),
              SizedBox(width: AppSize.p4),
            ],
            Text(
              text,
              style: TextStyle(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.commonText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSummary() {
    return Obx(() {
      if (uiController.custReportController.isLoading.value) {
        return Shimmer.fromColors(
          baseColor: AppColor.grey300.withOpacity(0.5),
          highlightColor: AppColor.white,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(AppSize.p12),
            ),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.all(AppSize.p12),
        decoration: BoxDecoration(
          color: AppColor.whiteOrang.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSize.p12),
          border: Border.all(color: AppColor.goldColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _summaryBox(
                "Total Given",
                uiController.custReportController.totalGivenAmt.value,
                AppColor.goldColor,
              ),
            ),
            SizedBox(width: AppSize.p12),
            Expanded(
              child: _summaryBox(
                "Total Pending",
                uiController.custReportController.totalPendingAmt.value,
                AppColor.black,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _summaryBox(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppSize.size12,
            color: AppColor.black.withOpacity(0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSize.p4),
        FittedBox(
          child: Text(
            "₹${amount.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: AppSize.size18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: inputField(
            hintText: AppString.fromDate,
            icon: AppIcon.calendar,
            iconColor: AppColor.goldColor,
            inputTextcontroller: uiController.fromDateController,
            readOnly: true,
            onTap: () => uiController.selectDate(
              context,
              uiController.fromDateController,
            ),
            suffixIcon: Icon(
              AppIcon.calendar,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
          ),
        ),
        SizedBox(width: AppSize.p12),
        Expanded(
          child: inputField(
            hintText: AppString.toDate,
            icon: AppIcon.calendar,
            iconColor: AppColor.goldColor,
            inputTextcontroller: uiController.toDateController,
            readOnly: true,
            onTap: () {
              uiController.selectDate(context, uiController.toDateController);
            },
            suffixIcon: Icon(
              AppIcon.calendar,
              color: AppColor.goldColor,
              size: AppSize.p20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockerFilter(BuildContext context) {
    return Obx(() {
      final lockerDisplayController = TextEditingController(
        text: uiController.selectedLocker.value,
      );
      return inputField(
        hintText: AppString.selectLocker,
        icon: AppIcon.locker,
        iconColor: AppColor.goldColor,
        inputTextcontroller: lockerDisplayController,
        readOnly: true,
        onTap: () => _showLockerSelectionDialog(context),
        suffixIcon: Icon(
          AppIcon.arrow_down,
          color: AppColor.goldColor,
          size: AppSize.p20,
        ),
      );
    });
  }

  void _showLockerSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          titlePadding: EdgeInsets.fromLTRB(
            AppSize.p16,
            AppSize.p16,
            AppSize.p16,
            AppSize.p8,
          ),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.p16),
            side: BorderSide(color: AppColor.goldColor.withOpacity(0.2)),
          ),
          title: Text(
            AppString.selectLockerTitle,
            style: TextStyle(
              color: AppColor.goldColor,
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.p16),
                  child: TextField(
                    controller: uiController.searchLockerController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        AppIcon.searchIcon,
                        color: AppColor.goldColor,
                        size: AppSize.p20,
                      ),
                      hintText: AppString.searchLockerHint,
                      hintStyle: TextStyle(
                        fontSize: AppSize.commonText,
                        color: AppColor.black.withOpacity(0.4),
                      ),
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColor.goldColor.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.goldColor),
                      ),
                    ),
                    onChanged: uiController.updateSearch,
                  ),
                ),
                SizedBox(height: AppSize.p8),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                    child: Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: AppSize.p8),
                        itemCount: uiController.filteredLockers.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: AppSize.p4 / 4,
                            indent: AppSize.p16,
                            endIndent: AppSize.p16,
                            color: AppColor.goldColor.withOpacity(0.1),
                          );
                        },
                        itemBuilder: (context, index) {
                          final locker = uiController.filteredLockers[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: AppSize.p16,
                            ),
                            title: Text(
                              "${locker.lockerCode} (${locker.comName})",
                              style: TextStyle(
                                fontSize: AppSize.commonText,
                                color: AppColor.black,
                              ),
                            ),
                            onTap: () {
                              uiController.selectLocker(locker);
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppString.cancel,
                style: TextStyle(
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
}
