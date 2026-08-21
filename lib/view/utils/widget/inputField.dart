// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/widget/inputField.dart';
import 'package:rukmini/view/utils/app_Color.dart';

Widget inputField({
  required String hintText,
  String? prefixIconPath,
  IconData? prefixIconData,
  dynamic icon,
  Color? iconColor,
  Color? textColor,
  bool isPassword = false,
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
    return TextField(
      autofocus: false,
      autocorrect: false,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      controller: inputTextcontroller,
      style: TextStyle(color: textColor ?? AppColor.loginTextDark),
      cursorColor: iconColor ?? AppColor.loginGold,
      obscureText: obscureText,
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: prefixIconData != null
            ? Icon(prefixIconData, color: iconColor ?? AppColor.loginGold)
            : (icon != null)
                ? Icon(icon is IconData ? icon : icon,
                    color: iconColor ?? AppColor.loginGold)
                : (prefixIconPath != null && prefixIconPath.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(prefixIconPath,
                            scale: 28, color: iconColor ?? AppColor.loginGold),
                      )
                    : null,
        prefixIconColor: iconColor ?? AppColor.loginGold,
        suffixIconColor: iconColor ?? AppColor.loginGold,
        suffixIcon: suffixIcon ??
            (isPassword
                ? IconButton(
                    onPressed: () => isvisorNot.obscureTextClick(),
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: iconColor ?? AppColor.loginGold,
                      size: 22,
                    ),
                  )
                : null),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: iconColor ?? AppColor.loginGold, width: 1.5),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.errorColor),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: (textColor ?? AppColor.loginTextDark).withOpacity(0.5)),
      ),
    );
  }

  return isPassword
      ? Obx(() => buildTextField(isvisorNot.obscureText.value))
      : buildTextField(false);
}
