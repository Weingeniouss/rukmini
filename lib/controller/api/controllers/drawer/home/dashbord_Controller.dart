// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../controller/local/localDatabase.dart';
import '../../../../../modal/drawer/home/dashboard_model.dart';
import '../../../services/drawer/home/dashbord_services.dart';

class DashbordController extends GetxController {
  final DashbordServices _dashbordServices = DashbordServices();
  var isLoading = false.obs;
  var dashboardData = DashboardModel().obs;

  Future<http.Response?> dashbord() async {
    try {
      isLoading.value = true;
      final http.Response response = await _dashbordServices.dashbordApi();
      if (kDebugMode) {
        print('Dashboard Status Code: ${response.statusCode}');
        print('Dashboard Response: ${response.body}');
      }
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = DashboardModel.fromJson(decoded);
          dashboardData.value = model;

          // Check for unauthorized access message in response
          final message = model.message?.toString().toLowerCase() ?? "";
          if (model.status == false && 
              (message.contains("authorized") || message.contains("permission"))) {
            print('Unauthorized detected in Controller! Redirecting...');
            await LocalDatabase().logout();
            Get.offAllNamed('/login');
          }
        }
      } else if (response.statusCode == 401) {
        print('401 Unauthorized detected! Redirecting...');
        await LocalDatabase().logout();
        Get.offAllNamed('/login');
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('Dashbord Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
