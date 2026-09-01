// ignore_for_file: file_names, avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/local/localDatabase.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import '../../controller/api/controllers/credentials/login_controller.dart';
import '../../modal/credentials/login_model.dart';
import '../../view/utils/widget/pop.dart';

Future postLogin() async {
  final LoginControllerAPI loginApi = Get.put(LoginControllerAPI());
  final localData = LocalDatabase();
  final http.Response? response = await loginApi.login();

  if (response != null) {
    String body = response.body;
    // Extract JSON if PHP errors are present
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final loginModel = LoginModel.fromJson(jsonDecode(body));
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
          userData: body,
        );
      } else {
        ToastificationError.Error(loginModel.message ?? AppString.loginFailed);
      }
    } else {
      ToastificationError.Error('${loginModel.message}');
    }
  } else {
    ToastificationError.Error(
      AppString.networkError,
    );
  }
}
