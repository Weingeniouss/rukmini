// ignore_for_file: strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/credentials/login_controller.dart';
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
    final loginAPI = Get.put(LoginControllerAPI());
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
                emailPhoneInput: loginAPI.loginUI.emailController,
                passwordInput: loginAPI.loginUI.passwordController,
              ),

              //button Login
              Obx(() => loginButton(loginAPI)),

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
  TextEditingController? emailPhoneInput,
  TextEditingController? passwordInput,
}) {
  return Padding(
    padding: EdgeInsets.only(right: Get.width * 0.2),
    child: Column(
      children: [
        inputField(
          hintText: AppString.emailphone,
          prefixIcon: AppIcon.user,
          inputTextcontroller: emailPhoneInput,
        ),
        inputField(
          hintText: AppString.password,
          prefixIcon: AppIcon.padlock,
          isPassword: true,
          inputTextcontroller: passwordInput,
        ),
      ],
    ),
  );
}

Widget loginButton(LoginControllerAPI loginUI) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: Get.height * 0.10),
        child: GestureDetector(
          onTap: (){
            CallApi.callLogin();
          },
          child: loginUI.isLoading.value
              ? CircularProgressIndicator(color: AppColor.fullScreenColor)
              : Image.asset(AppIcon.btLogin, scale: 2.3),
        ),
      ),
    ],
  );
}

Widget forgetpasswod({required void Function()? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      AppString.forgetPassword,
      style: TextStyle(color: AppColor.fullScreenColor),
    ),
  );
}
