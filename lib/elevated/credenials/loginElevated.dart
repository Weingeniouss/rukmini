
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/api/controllers/credentials/login_controller.dart';
import '../../modal/credentials/login_model.dart';
import '../../view/utils/widget/pop.dart';

Future postLogin() async {
  final LoginControllerAPI loginApi = Get.put(LoginControllerAPI());
  final http.Response? response = await loginApi.login();
  String? loginTokan;

  if (response != null) {
    if (response.statusCode == 200) {
      final loginModel = LoginModel.fromJson(jsonDecode(response.body));
      if (loginModel.status == true) {
        ToastificationSuccess.Success(loginModel.message!);
        loginTokan = loginModel.data!.loginToken;
        print("$loginTokan :- loginTokan");
      } else {
        ToastificationError.Error(loginModel.message ?? 'Login failed');
      }
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  }
}
