// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/api/controllers/home/dashbord_Controller.dart';
import '../../modal/home/dashboard_model.dart';
import '../../view/utils/widget/pop.dart';

Future<DashboardModel?> getDashboard() async {
  final DashbordController dashboardController = Get.put(DashbordController());
  final http.Response? response = await dashboardController.dashbord();

  if (response != null) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final dashboardModel = DashboardModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (dashboardModel.status == true) {
          return dashboardModel;
        } else {
          ToastificationError.Error(
              dashboardModel.message ?? 'Failed to load dashboard');
        }
      } else {
        ToastificationError.Error('Server Error: ${response.statusCode}');
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
