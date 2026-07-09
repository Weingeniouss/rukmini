// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';

Widget headingContainer(String title) {
  return Container(
    padding: EdgeInsets.all(Get.width * 0.04),
    decoration: BoxDecoration(color: AppColor.subHeadingContainerColor),
    width: Get.width,
    child: Text(
      title,
      style: TextStyle(
        fontSize: Get.width * 0.038,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
