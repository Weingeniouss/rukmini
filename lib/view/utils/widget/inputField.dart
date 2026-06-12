// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Color.dart';

Widget inputField({
  required String hintText,
  required String prefixIcon,
  bool isPassword = false,
  TextEditingController? inputTextcontroller,
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
        prefixIcon: Padding(
          padding: EdgeInsets.all(12.0),
          child: Image.asset(prefixIcon, scale: 28, color: AppColor.textField),
        ),
        prefixIconColor: AppColor.textField,
        suffixIconColor: AppColor.textField,
        suffixIcon: isPassword
            ? IconButton(
                onPressed: () => isvisorNot.obscureTextClick(),
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColor.textField,
                  size: 22,
                ),
              )
            : null,
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
