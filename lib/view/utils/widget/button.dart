import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';

Widget clickButton(String name) {
  return Container(
    padding: EdgeInsets.all(12),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      border: Border.all(color: AppColor.textColor),
    ),
    child: Center(
      child: Text(name, style: TextStyle(fontWeight: FontWeight.w500)),
    ),
  );
}
