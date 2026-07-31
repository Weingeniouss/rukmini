// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
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
      appBar: appBar(title: AppString.allMasters),
      child: Column(
        children: [
          _buildMasterItem(
            icon: AppIcon.grid,
            title: AppString.metalMaster,
            onTap: () {
              Get.toNamed('/metalMaster');
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.category,
            title: AppString.productCategoryMaster,
            onTap: () {
              Get.toNamed('/categoryMaster');
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.personOutline,
            title: AppString.customerTypeMaster,
            onTap: () {
              Get.toNamed('/customerTypeMaster');
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.security,
            title: AppString.lockerCodeMaster,
            onTap: () {
              Get.toNamed('/lockerCodeMaster');
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.balance,
            title: AppString.metalTouchMaster,
            onTap: () {
              // TODO: Navigate to Metal Touch
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.calendar,
            title: AppString.yearMaster,
            onTap: () {
              // TODO: Navigate to Year Master
            },
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildMasterItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: AppColor.activeColor.withOpacity(0.7),
        size: Get.width * 0.06,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.activeColor,
          fontSize: Get.width * 0.042,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        AppIcon.rightArrow,
        color: AppColor.activeColor.withOpacity(0.7),
        size: Get.width * 0.06,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: Get.width * 0.05,
        vertical: Get.height * 0.005,
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColor.boderSideColor.shade200,
      indent: 0,
      endIndent: 0,
    );
  }
}
