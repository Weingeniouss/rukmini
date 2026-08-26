// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';

class AllMaster extends StatelessWidget {
  const AllMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      drawer: homeDrawer(),
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(title: _buildDecorativeTitle(), centerTitle: true),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p12,
        ),
        child: Column(
          children: [
            _buildMasterItem(
              icon: AppIcon.grid,
              title: AppString.metalMaster,
              onTap: () => Get.toNamed('/metalMaster'),
            ),
            _buildMasterItem(
              icon: AppIcon.category,
              title: AppString.productCategoryMaster,
              onTap: () => Get.toNamed('/categoryMaster'),
            ),
            _buildMasterItem(
              icon: AppIcon.personOutline,
              title: AppString.customerTypeMaster,
              onTap: () => Get.toNamed('/customerTypeMaster'),
            ),
            _buildMasterItem(
              icon: AppIcon.security,
              title: AppString.lockerCodeMaster,
              onTap: () => Get.toNamed('/lockerCodeMaster'),
            ),
            _buildMasterItem(
              icon: AppIcon.balance,
              title: AppString.metalTouchMaster,
              onTap: () => Get.toNamed('/metalTouch'),
            ),
            _buildMasterItem(
              icon: AppIcon.calendar,
              title: AppString.yearMaster,
              onTap: () => Get.toNamed('/yearMaster'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppString.allMasters,
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
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: 6,
                  height: 6,
                  color: AppColor.goldColor,
                ),
              ),
            ),
            Container(
              width: AppSize.width * 0.1,
              height: 1,
              color: AppColor.goldColor.withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMasterItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.p12),
        child: IntrinsicHeight(
          child: InkWell(
            onTap: onTap,
            child: Row(
              children: [
                // Left gold indicator
                Container(width: 4, color: AppColor.goldColor),
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
                        width: 1,
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
                  child: Icon(
                    AppIcon.rightArrow,
                    color: AppColor.goldColor,
                    size: AppSize.p20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
