// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import '../app_Icon.dart';

AppBar appBar({required String title}) {
  return AppBar(
    leading: Builder(builder: (context) {
      return GestureDetector(
        onTap: () {
          Scaffold.of(context).openDrawer();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
          child: SvgPicture.asset(AppIcon.openMenu),
        ),
      );
    }),
    primary: true,
    title: Text(
      title,
      style: TextStyle(
        color: AppColor.fullScreenColor,
        fontSize: Get.width * 0.05,
        fontWeight: FontWeight.w600,
      ),
    ),
    backgroundColor: AppColor.primaryColor,
  );
}
