// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/appBar.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginControllerAPI>();

    return Fullscreen(
      isPadding: false,
      backGroundcolor: AppColor.backgroundColor,
      appBar: appBar(back: true, title: AppString.user, centerTitle: true),
      child: Obx(() {
        final userData = loginController.loginData.value.data;
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildProfileHeader(userData),
              SizedBox(height: AppSize.p24),
              horizontalPadding(child: _buildInfoSection(userData)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(dynamic userData) {
    return horizontalPadding(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: AppSize.p24),
        margin: EdgeInsets.only(top: AppSize.p16),
        decoration: BoxDecoration(
          color: AppColor.whiteOrang.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColor.goldColor.withOpacity(0.1)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.goldColor.withOpacity(0.4),
              AppColor.whiteOrang,
              AppColor.goldColor.withOpacity(0.1),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.goldColor.withOpacity(0.3)),
              ),
              child: CircleAvatar(
                radius: AppSize.width * 0.13,
                backgroundColor: AppColor.white,
                child: Text(
                  _getInitials(userData?.roleName),
                  style: TextStyle(
                    fontSize: AppSize.extraLargeText * 1.4,
                    fontWeight: FontWeight.bold,
                    color: AppColor.goldColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.p16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDecorationLine(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.p12),
                  child: Text(
                    userData?.roleName ?? AppString.user,
                    style: TextStyle(
                      fontSize: AppSize.titleText,
                      fontWeight: FontWeight.bold,
                      color: AppColor.black,
                    ),
                  ),
                ),
                _buildDecorationLine(isRight: true),
              ],
            ),
            SizedBox(height: AppSize.p4),
            Text(
              userData?.email ?? '',
              style: TextStyle(
                fontSize: AppSize.commonText,
                color: AppColor.goldColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorationLine({bool isRight = false}) {
    return Row(
      children: [
        if (!isRight)
          Container(
            width: 30,
            height: 1,
            color: AppColor.goldColor.withOpacity(0.3),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            AppIcon.star,
            size: 10,
            color: AppColor.goldColor.withOpacity(0.5),
          ),
        ),
        if (isRight)
          Container(
            width: 30,
            height: 1,
            color: AppColor.goldColor.withOpacity(0.3),
          ),
      ],
    );
  }

  Widget _buildInfoSection(dynamic userData) {
    return Column(
      children: [
        _buildInfoRow(
          AppIcon.person,
          AppString.userId,
          userData?.userId ?? AppString.na,
        ),
        _buildInfoRow(
          AppIcon.phone,
          AppString.phone,
          userData?.phone ?? AppString.na,
        ),
        _buildInfoRow(
          AppIcon.badge,
          AppString.roleId,
          userData?.roleId ?? AppString.na,
        ),
        _buildInfoRow(
          AppIcon.verifiedUser,
          AppString.superUser,
          userData?.isSupper == "1" ? AppString.yes : AppString.no,
        ),
        _buildInfoRow(
          AppIcon.status,
          AppString.status,
          userData?.status ?? AppString.na,
          isStatus: true,
        ),
        SizedBox(height: AppSize.p40),
      ],
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    bool isStatus = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSize.p12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.whiteOrang.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColor.goldColor, size: 22),
            ),
            SizedBox(width: AppSize.p16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: AppSize.smallText,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (isStatus)
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColor.activeColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          value,
                          style: TextStyle(
                            fontSize: AppSize.commonText,
                            fontWeight: FontWeight.bold,
                            color: AppColor.activeColor,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: AppSize.commonText,
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              AppIcon.rightArrow,
              color: AppColor.goldColor.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return "U";
    List<String> names = name.split(" ");
    String initials = "";
    int numWords = 2;
    if (names.length < numWords) numWords = names.length;
    for (var i = 0; i < numWords; i++) {
      initials += names[i][0];
    }
    return initials.toUpperCase();
  }
}
