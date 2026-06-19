// ignore_for_file: file_names, camel_case_types

import 'package:flutter/foundation.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
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
      if (kDebugMode) print('forgotPassword Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
