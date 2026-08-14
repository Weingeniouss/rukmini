// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../../controller/api/controllers/drawer/home/dashbord_Controller.dart';
import '../../../controller/local/localDatabase.dart';
import '../../../modal/drawer/home/dashboard_model.dart';
import '../../../view/utils/widget/pop.dart';

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
          final message =
              dashboardModel.message?.toString().toLowerCase() ?? "";
          if (message.contains("authorized") ||
              message.contains("permission")) {
            if (kDebugMode) {
              print('Relocating to login due to unauthorized access...');
            }
            await LocalDatabase().logout();
            Get.offAllNamed('/login');
            return null;
          }
          ToastificationError.Error(
            dashboardModel.message ?? AppString.failedToLoadDashboard,
          );
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
