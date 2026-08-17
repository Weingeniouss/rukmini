// ignore_for_file: file_names, camel_case_types

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/credentials/forgotPasswordServices.dart';
import '../../../ui/credentials/login_controllerUI.dart';
import 'package:http/http.dart' as http;

class ForgotPassword_ControllerAPI extends GetxController {
  final LoginControllerUi loginUI = Get.put(LoginControllerUi());
  final forgotPasswordServices _forgotPasswordServices =
      forgotPasswordServices();

  var isLoading = false.obs;

  Future<http.Response?> forgotPassword() async {
    try {
      isLoading.value = true;
      final http.Response response = await _forgotPasswordServices
          .forgotPasswordApi();
      return response;
    } catch (e) {
      if (kDebugMode) print('forgotPassword ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
