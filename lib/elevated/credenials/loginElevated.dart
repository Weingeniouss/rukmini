// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/local/localDatabase.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import '../../controller/api/controllers/credentials/login_controller.dart';
import '../../modal/credentials/login_model.dart';
import '../../view/utils/widget/pop.dart';

Future postLogin() async {
  final LoginControllerAPI loginApi = Get.put(LoginControllerAPI());
  final localData = LocalDatabase();
  final http.Response? response = await loginApi.login();

  if (response != null) {
    final loginModel = LoginModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      if (loginModel.status == true) {
        ToastificationSuccess.Success(loginModel.message!);
        tokans = loginModel.data!.loginToken!;
        print("$tokans :- loginTokan");
        // this page navigate to home
        Get.toNamed('/home');
        //Save Data for Localy Your Mobile Device
        localData.loginSaveData(
          email: loginApi.loginUI.emailController.text,
          password: loginApi.loginUI.passwordController.text,
          uId: loginModel.data!.userId,
        );
      } else {
        ToastificationError.Error(loginModel.message ?? 'Login failed');
      }
    } else {
      ToastificationError.Error('${loginModel.message}');
    }
  }
}
