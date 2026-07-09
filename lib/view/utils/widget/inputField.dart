// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';

Widget inputField({
  required String hintText,
  String? prefixIcon,
  dynamic icon,
  Color? iconColor,
  bool isPassword = false,
  TextEditingController? inputTextcontroller,
  Widget? suffixIcon,
}) {
  // Use hintText as tag to ensure each field gets its own controller instance
  final isvisorNot = Get.put(InputFieldController(), tag: hintText);

  // Initialize obscureText to true if it's a password field
  if (isPassword && isvisorNot.obscureText.value == false) {
    isvisorNot.obscureText.value = true;
  }

  Widget buildTextField(bool obscureText) {
    return TextField(
      controller: inputTextcontroller,
      style: TextStyle(color: AppColor.textField),
      cursorColor: AppColor.textField,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: (icon != null)
            ? Icon(icon is IconData ? icon : icon,
                color: iconColor ?? AppColor.textField)
            : (prefixIcon != null && prefixIcon.isNotEmpty)
                ? Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Image.asset(prefixIcon,
                        scale: 28, color: iconColor ?? AppColor.textField),
                  )
                : null,
        prefixIconColor: iconColor ?? AppColor.textField,
        suffixIconColor: iconColor ?? AppColor.textField,
        suffixIcon: suffixIcon ??
            (isPassword
                ? IconButton(
                    onPressed: () => isvisorNot.obscureTextClick(),
                    icon: Icon(
                      obscureText
                          ? AppIcon.visibilityOff
                          : AppIcon.visibilityOn,
                      color: iconColor ?? AppColor.textField,
                      size: 22,
                    ),
                  )
                : null),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.textField),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.textField),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.textField),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.textField),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: AppColor.textField.withOpacity(0.7)),
      ),
    );
  }

  return isPassword
      ? Obx(() => buildTextField(isvisorNot.obscureText.value))
      : buildTextField(false);
}
