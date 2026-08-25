// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';

Widget inputField({
  required String hintText,
  String? prefixIconPath,
  IconData? prefixIconData,
  dynamic icon,
  Color? iconColor,
  Color? textColor,
  bool isPassword = false,
  bool readOnly = false,
  VoidCallback? onTap,
  TextEditingController? inputTextcontroller,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  int? maxLength,
  List<TextInputFormatter>? inputFormatters,
}) {
  // Use hintText as tag to ensure each field gets its own controller instance
  final isvisorNot = Get.put(InputFieldController(), tag: hintText);

  // Initialize obscureText to true if it's a password field
  if (isPassword && isvisorNot.obscureText.value == false) {
    isvisorNot.obscureText.value = true;
  }

  Widget buildTextField(bool obscureText) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p12),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p12),
        border: Border.all(color: AppColor.grey300.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.02),
            blurRadius: AppSize.p4 + 1,
            offset: Offset(0, AppSize.p4 / 2),
          ),
        ],
      ),
      child: TextField(
        autofocus: false,
        autocorrect: false,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        controller: inputTextcontroller,
        style: TextStyle(
          color: textColor ?? AppColor.loginTextDark,
          fontSize: AppSize.commonText,
        ),
        cursorColor: iconColor ?? AppColor.goldColor,
        obscureText: obscureText,
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: prefixIconData != null
              ? Icon(
                  prefixIconData,
                  color: iconColor ?? AppColor.goldColor,
                  size: AppSize.p20,
                )
              : (icon != null)
                  ? Icon(
                      icon is IconData ? icon : icon,
                      color: iconColor ?? AppColor.goldColor,
                      size: AppSize.p20,
                    )
                  : (prefixIconPath != null && prefixIconPath.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.all(AppSize.p12),
                          child: Image.asset(
                            prefixIconPath,
                            scale: 28,
                            color: iconColor ?? AppColor.goldColor,
                          ),
                        )
                      : null,
          suffixIcon: suffixIcon ??
              (isPassword
                  ? IconButton(
                      onPressed: () => isvisorNot.obscureTextClick(),
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: iconColor ?? AppColor.goldColor,
                        size: 22,
                      ),
                    )
                  : null),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: AppSize.p16,
            horizontal: AppSize.p16,
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: (textColor ?? AppColor.loginTextDark).withOpacity(0.5),
            fontSize: AppSize.commonText,
          ),
        ),
      ),
    );
  }

  return isPassword
      ? Obx(() => buildTextField(isvisorNot.obscureText.value))
      : buildTextField(false);
}
