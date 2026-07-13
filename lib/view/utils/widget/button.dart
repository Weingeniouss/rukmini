import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_Color.dart';

Widget clickButton(String name, {bool isLoading = false}) {
  return Container(
    padding: const EdgeInsets.all(12),
    width: Get.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(3),
      border: Border.all(color: AppColor.textColor),
    ),
    child: Center(
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primaryColor,
              ),
            )
          : Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
    ),
  );
}
