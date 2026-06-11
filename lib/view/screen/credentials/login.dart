// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/ui/credentials/login.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_logo.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:rukmini/view/utils/widget/horizontalPadding.dart';
import 'package:rukmini/view/utils/widget/inputField.dart';
import '../../utils/app_background.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final loginUI = Get.put(LoginControllerUI());
    return Fullscreen(
      backgroundImage: AppBackground.loginImage,
      child: horizontalPadding(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Logo
              logo(AppLogo.rukminiLogo2),

              //Heding
              heding(),

              //Login TextField
              loginTextField(
                inputTextcontrollerEmailPhone: loginUI.emailController,
                inputTextcontrollerPassword: loginUI.passwordController,
              ),

              //button Login
              loginButton(),

              //Forget Password
              forgetpasswod(onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

Widget logo(logo) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [Image.asset(logo, scale: 3)],
  );
}

Widget heding() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: Get.height * 0.020),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppString.welcome,
          style: TextStyle(
            color: AppColor.fullScreenColor,
            fontSize: Get.width * 0.04,
          ),
        ),
        Text(
          AppString.rukminiJewellers,
          style: TextStyle(
            color: AppColor.fullScreenColor,
            fontSize: Get.width * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget loginTextField({
  TextEditingController? inputTextcontrollerEmailPhone,
  TextEditingController? inputTextcontrollerPassword,
}) {
  return Padding(
    padding: EdgeInsets.only(right: Get.width * 0.2),
    child: Column(
      children: [
        inputField(
          hintText: AppString.emailphone,
          prefixIcon: AppIcon.user,
          inputTextcontroller: inputTextcontrollerEmailPhone,
        ),
        inputField(
          hintText: AppString.password,
          prefixIcon: AppIcon.padlock,
          isPassword: true,
          inputTextcontroller: inputTextcontrollerPassword,
        ),
      ],
    ),
  );
}

Widget loginButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.10),
        child: Image.asset(AppIcon.btLogin, scale: 2.3),
      ),
    ],
  );
}

Widget forgetpasswod({required void Function()? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      'Forget Password?',
      style: TextStyle(color: AppColor.fullScreenColor),
    ),
  );
}
