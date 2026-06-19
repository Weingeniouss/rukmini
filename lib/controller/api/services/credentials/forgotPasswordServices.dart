// ignore_for_file: camel_case_types, file_names

import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../ui/credentials/login_controllerUI.dart';
import 'package:http/http.dart' as http;

class forgotPasswordServices {
  final LoginControllerUi loginUI = Get.put(LoginControllerUi());
  final String url = AppUrl.forgetPassword;
  late final login = Uri.parse(url);
  final apiKey = AppUrl.apiKey;

  Future<http.Response> forgotPasswordApi() async {
    final body = {
      AppString.emailBody: loginUI.emailController.text,
      AppString.apiKey: apiKey,
    };
    return await http.post(login, body: body);
  }
}
