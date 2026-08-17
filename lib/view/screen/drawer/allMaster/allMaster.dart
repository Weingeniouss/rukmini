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
              Get.toNamed('/metalTouch');
            },
          ),
          _buildDivider(),
          _buildMasterItem(
            icon: AppIcon.calendar,
            title: AppString.yearMaster,
            onTap: () {
              Get.toNamed('/yearMaster');
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
        size: AppSize.p24,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColor.activeColor,
          fontSize: AppSize.p16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        AppIcon.rightArrow,
        color: AppColor.activeColor.withOpacity(0.7),
        size: AppSize.p24,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSize.p20,
        vertical: AppSize.p4,
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
