import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_constants.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/ui/credentials/login_controllerUI.dart';
import 'package:rukmini/modal/credentials/login_model.dart';
import '../../services/credentials/loginServices.dart';

class LoginControllerAPI extends GetxController {
  final LoginControllerUi loginUI = Get.put(LoginControllerUi());
  final LoginServices _loginServices = LoginServices();

  var isLoading = false.obs;
  var loginData = LoginModel().obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedUserData();
  }

  void _loadSavedUserData() {
    if (pref != null) {
      String? savedData = pref!.getString('userData');
      if (savedData != null && savedData.isNotEmpty) {
        try {
          loginData.value = LoginModel.fromJson(jsonDecode(savedData));
        } catch (e) {
          if (kDebugMode) print('Error loading saved user data: $e');
        }
      }
    }
  }

  Future<http.Response?> login() async {
    try {
      isLoading.value = true;
      final http.Response response = await _loginServices.loginApi();
      if (kDebugMode) {
        print('--- Login ${AppString.responseLog} ---');
        print('${AppString.statusCodeLog}${response.statusCode}');
        print('${AppString.bodyLog}${response.body}');
        print('--- Login ${AppString.responseLog} ---');
      }
      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          loginData.value = LoginModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('Login ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
