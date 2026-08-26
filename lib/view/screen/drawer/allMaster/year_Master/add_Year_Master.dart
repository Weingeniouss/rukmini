// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/home/allMaster/year_Master/yearMaster_ControllerUI.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

class AddYearMaster extends StatelessWidget {
  final YearMasterControllerUI uiController;

  const AddYearMaster({super.key, required this.uiController});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(
        centerTitle: true,
        back: true,
        title: _buildDecorativeTitle(),
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: AppSize.p12),
              child: horizontalPadding(
                child: Column(
                  children: [
                    _buildSectionHeader(
                      AppString.addYearMaster,
                      AppIcon.calendar,
                    ),
                    SizedBox(height: AppSize.p16),
                    inputField(
                      hintText: AppString.title,
                      icon: AppIcon.badge,
                      iconColor: AppColor.goldColor,
                      inputTextcontroller: uiController.titleController,
                    ),
                    inputField(
                      hintText: AppString.fromDate,
                      icon: AppIcon.calendar,
                      iconColor: AppColor.goldColor,
                      inputTextcontroller: uiController.fromDateController,
                      readOnly: true,
                      onTap: () => uiController.selectDate(
                        context,
                        uiController.fromDateController,
                        true,
                      ),
                      suffixIcon: Icon(
                        AppIcon.calendar,
                        color: AppColor.goldColor,
                        size: AppSize.p20,
                      ),
                    ),
                    inputField(
                      hintText: AppString.toDate,
                      icon: AppIcon.calendar,
                      iconColor: AppColor.goldColor,
                      inputTextcontroller: uiController.toDateController,
                      readOnly: true,
                      onTap: () => uiController.selectDate(
                        context,
                        uiController.toDateController,
                        false,
                      ),
                      suffixIcon: Icon(
                        AppIcon.calendar,
                        color: AppColor.goldColor,
                        size: AppSize.p20,
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        title: Text(
                          AppString.setAsDefaultYear,
                          style: TextStyle(
                            fontSize: AppSize.commonText,
                            fontWeight: FontWeight.w500,
                            color: AppColor.black,
                          ),
                        ),
                        value: uiController.isDefaultYear.value,
                        onChanged: (val) {
                          uiController.isDefaultYear.value = val ?? false;
                        },
                        activeColor: AppColor.goldColor,
                        checkColor: AppColor.white,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomActionRow(),
        ],
      ),
    );
  }

  Widget _buildDecorativeTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.yearMaster,
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
                  width: AppSize.p8,
                  height: AppSize.p8,
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

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.p16,
        vertical: AppSize.p12,
      ),
      decoration: BoxDecoration(
        color: AppColor.whiteOrang.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSize.p20),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSize.p8),
            decoration: BoxDecoration(
              color: AppColor.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.goldColor.withOpacity(0.1),
                  blurRadius: AppSize.p4,
                ),
              ],
            ),
            child: Icon(icon, color: AppColor.goldColor, size: AppSize.p20),
          ),
          SizedBox(width: AppSize.p12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppSize.headingText,
              fontWeight: FontWeight.bold,
              color: AppColor.black,
            ),
          ),
          const Spacer(),
          Icon(
            AppIcon.leaf,
            color: AppColor.goldColor.withOpacity(0.1),
            size: AppSize.iconLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionRow() {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: AppSize.p10,
            offset: Offset(0, -AppSize.p4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                side: BorderSide(
                  color: AppColor.goldColor,
                  width: AppSize.p4 * 0.375,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.p16),
                ),
              ),
              child: Text(
                AppString.cancel,
                style: TextStyle(
                  color: AppColor.goldColor,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.largeText,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSize.p16),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.goldColor, AppColor.dashboardGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppSize.p16),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.goldColor.withOpacity(0.3),
                    blurRadius: AppSize.p8,
                    offset: Offset(0, AppSize.p4),
                  ),
                ],
              ),
              child: Obx(
                () => ElevatedButton(
                  onPressed: uiController.isLoading.value
                      ? null
                      : () => uiController.submit(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.transparent,
                    shadowColor: AppColor.transparent,
                    padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.p16),
                    ),
                  ),
                  child: uiController.isLoading.value
                      ? SizedBox(
                          height: AppSize.p20,
                          width: AppSize.p20,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSize.p4 / 2,
                            color: AppColor.white,
                          ),
                        )
                      : Text(
                          AppString.save,
                          style: TextStyle(
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                            fontSize: AppSize.largeText,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
