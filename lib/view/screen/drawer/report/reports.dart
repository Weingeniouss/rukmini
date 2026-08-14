// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class Reports extends StatelessWidget {
  Reports({super.key});

  final uiController = Get.put(ReportUIController());

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      drawer: homeDrawer(),
      appBar: appBar(title: AppString.reports, back: false),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
        child: Column(
          children: [
            _buildReportCard(
              index: 0,
              title: AppString.customerReport,
              icon: AppIcon.person,
              child: _buildDateRangeFilter(context),
            ),
            _buildReportCard(
              index: 1,
              title: AppString.girviReport,
              icon: AppIcon.grid,
              child: _buildDateRangeFilter(context),
            ),
            _buildReportCard(
              index: 2,
              title: AppString.lockerWiseReport,
              icon: AppIcon.locker,
              child: _buildLockerFilter(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required int index,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return horizontalPadding(
      child: Obx(() {
        bool isExpanded = uiController.expandedIndex.value == index;
        return Container(
          margin: EdgeInsets.only(bottom: Get.height * 0.02),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: AppColor.black.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            border: Border.all(color: AppColor.grey200),
          ),
          child: Column(
            children: [
              ListTile(
                onTap: () => uiController.toggleExpansion(index),
                leading: Icon(icon, color: AppColor.activeColor),
                title: Text(
                  title,
                  style: TextStyle(
                    fontSize: Get.width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: AppColor.dark,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.cancel_outlined : Icons.add_circle_outline,
                  color: isExpanded
                      ? AppColor.deleteColor
                      : AppColor.activeColor,
                  size: Get.width * 0.07,
                ),
              ),
              if (isExpanded) ...[
                Divider(height: 1),
                Padding(
                  padding: EdgeInsets.all(Get.width * 0.04),
                  child: child,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Get.width * 0.04,
                      bottom: Get.width * 0.04,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.activeColor,
                        foregroundColor: AppColor.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.06,
                          vertical: Get.height * 0.01,
                        ),
                      ),
                      child: Text(AppString.viewReport),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return Row(
      children: [
        Icon(AppIcon.calendar, color: AppColor.activeColor, size: 24),
        SizedBox(width: Get.width * 0.04),
        Expanded(
          child: _buildInlineDateField(
            context: context,
            controller: uiController.fromDateController,
            hint: AppString.fromDate,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            "-",
            style: TextStyle(fontSize: 20, color: AppColor.grey500),
          ),
        ),
        Expanded(
          child: _buildInlineDateField(
            context: context,
            controller: uiController.toDateController,
            hint: AppString.toDate,
          ),
        ),
      ],
    );
  }

  Widget _buildInlineDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String hint,
  }) {
    return GestureDetector(
      onTap: () => uiController.selectDate(context, controller),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColor.grey300)),
        ),
        child: TextField(
          controller: controller,
          enabled: false,
          style: TextStyle(fontSize: Get.width * 0.038),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildLockerFilter(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showLockerSelectionDialog(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColor.grey300)),
            ),
            child: Row(
              children: [
                Icon(AppIcon.locker, color: AppColor.activeColor, size: 24),
                SizedBox(width: Get.width * 0.04),
                Expanded(
                  child: Obx(
                    () => Text(
                      uiController.selectedLocker.value.isEmpty
                          ? AppString.selectLocker
                          : uiController.selectedLocker.value,
                      style: TextStyle(
                        fontSize: Get.width * 0.038,
                        color: uiController.selectedLocker.value.isEmpty
                            ? AppColor.textColor
                            : AppColor.dark,
                      ),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColor.activeColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showLockerSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColor.white,
          titlePadding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          title: Text(
            AppString.selectLockerTitle,
            style: TextStyle(color: AppColor.activeColor, fontSize: 18),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: uiController.searchLockerController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        AppIcon.searchIcon,
                        color: AppColor.black,
                        size: 20,
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 30,
                        minHeight: 0,
                      ),
                      hintText: AppString.searchLockerHint,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.grey300),
                      ),
                    ),
                    onChanged: uiController.updateSearch,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxHeight: Get.height * 0.4),
                    child: Obx(() {
                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: uiController.filteredLockers.length,
                        separatorBuilder: (context, index) {
                          return Divider(height: 1, indent: 16, endIndent: 16);
                        },
                        itemBuilder: (context, index) {
                          final locker = uiController.filteredLockers[index];
                          return ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            title: Text(
                              "${locker.lockerCode} (${locker.comName})",
                              style: TextStyle(fontSize: 15),
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
                AppString.ok,
                style: TextStyle(color: AppColor.activeColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
