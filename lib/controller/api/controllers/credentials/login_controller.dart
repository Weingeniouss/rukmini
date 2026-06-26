import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/ui/credentials/login_controllerUI.dart';
import 'package:rukmini/modal/credentials/login_model.dart';
import '../../services/credentials/loginServices.dart';

class LoginControllerAPI extends GetxController {
  final LoginControllerUi loginUI = Get.put(LoginControllerUi());
  final LoginServices _loginServices = LoginServices();

  var isLoading = false.obs;
  var loginData = LoginModel().obs;

  Future<http.Response?> login() async {
    try {
      isLoading.value = true;
      final http.Response response = await _loginServices.loginApi();
      if (kDebugMode) {
        print('Login Response: ${response.body}');
      }
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          loginData.value = LoginModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('Login Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
