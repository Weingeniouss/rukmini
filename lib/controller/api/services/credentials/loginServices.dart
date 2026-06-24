// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../ui/credentials/login_controllerUI.dart';
import 'package:http/http.dart' as http;

class LoginServices {
  final LoginControllerUi loginUI = Get.put(LoginControllerUi());
  final String url = AppUrl.login;
  late final login = Uri.parse(url);
  final apiKey = AppUrl.apiKey;

  Future<http.Response> loginApi() async {
    final body = {
      AppString.emailBody: loginUI.emailController.text,
      AppString.passwordBody: loginUI.passwordController.text,
      AppString.apiKey: apiKey,
    };

    if (kDebugMode) {
      print('--- Login API Request ---');
      print('URL: $url');
      print('body: $body');
      print('--- Login API Request ---');
    }

    return await http.post(login, body: body);
  }
}
