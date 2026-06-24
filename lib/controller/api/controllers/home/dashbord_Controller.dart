// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../modal/home/dashboard_model.dart';
import '../../services/home/dashbord_services.dart';

class DashbordController extends GetxController {
  final DashbordServices _dashbordServices = DashbordServices();
  var isLoading = false.obs;
  var dashboardData = DashboardModel().obs;

  Future<http.Response?> dashbord() async {
    try {
      isLoading.value = true;
      final http.Response response = await _dashbordServices.dashbordApi();
      if (kDebugMode) {
        print('Dashboard Response: ${response.body}');
      }
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          dashboardData.value = DashboardModel.fromJson(decoded);
        }
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
