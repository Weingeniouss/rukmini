// ignore_for_file: file_names

import 'package:get/get.dart';
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
      'Email': loginUI.emailController.text,
      'Password': loginUI.passwordController.text,
      'API-KEY': apiKey,
    };
    return await http.post(login, body: body);
  }
}
