import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/credentials/forgot_password_service.dart';
import 'package:rukmini/modal/credentials/forgot_password_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordServices _services = ForgotPasswordServices();
  var isLoading = false.obs;
  final emailController = TextEditingController();

  Future<http.Response?> forgotPassword() async {
    if (emailController.text.isEmpty) {
      ToastificationError.Error("Please enter your email");
      return null;
    }

    try {
      isLoading.value = true;
      final http.Response response = await _services.forgotPasswordApi(
        email: emailController.text,
      );

      if (kDebugMode) {
        print('ForgotPassword ${AppString.responseLog}: ${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = ForgotPasswordModel.fromJson(decoded);
          if (model.status == true) {
            ToastificationSuccess.Success(model.message ?? "Password reset link sent!");
            emailController.clear();
            Get.back(); // Close the popup
          } else {
            ToastificationError.Error(model.message ?? "Please enter the correct email");
          }
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('ForgotPassword ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
