import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/credentials/forgot_password_controller.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';

void showForgotPasswordPopup(BuildContext context) {
  final controller = Get.put(ForgotPasswordController());

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColor.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          AppString.forgetPassword,
          style: TextStyle(
            color: AppColor.primaryColor,
            fontSize: AppSize.size18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Enter your registered email to receive a password reset link.",
              style: TextStyle(fontSize: AppSize.size14, color: AppColor.textColor),
            ),
            SizedBox(height: AppSize.p16),
            inputField(
              hintText: "Email",
              prefixIcon: AppIcon.user,
              inputTextcontroller: controller.emailController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.emailController.clear();
              Navigator.pop(context);
            },
            child: Text(
              AppString.cancel,
              style: TextStyle(color: AppColor.textColor),
            ),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.forgotPassword(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColor.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Send",
                    style: TextStyle(color: AppColor.white),
                  ),
          )),
        ],
      );
    },
  );
}
