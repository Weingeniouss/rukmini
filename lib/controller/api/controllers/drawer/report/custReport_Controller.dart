// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/report/custReport_service.dart';
import 'package:rukmini/modal/drawer/report/customer_report_model.dart';
import 'package:rukmini/view/utils/app_String.dart';

class CustReportController extends GetxController {
  final CustReportServices _services = CustReportServices();
  var isLoading = false.obs;
  
  var reportData = CustomerReportModel().obs;
  var customerReports = <CustomerReportData>[].obs;
  
  var totalGivenAmt = 0.0.obs;
  var totalPendingAmt = 0.0.obs;

  Future<http.Response?> getCustReport({
    String? search,
    String? fromDate,
    String? toDate,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.custReportApi(
        search: search,
        fromDate: fromDate,
        toDate: toDate,
      );

      if (kDebugMode) {
        print('CustReport ${AppString.responseLog}: ${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final newData = CustomerReportModel.fromJson(decoded);
          reportData.value = newData;
          
          if (newData.status == true) {
            customerReports.assignAll(newData.data ?? []);
            totalGivenAmt.value = double.tryParse(newData.givenAmt?.toString() ?? '0') ?? 0.0;
            totalPendingAmt.value = double.tryParse(newData.pendingAmt?.toString() ?? '0') ?? 0.0;
          } else {
            customerReports.clear();
            totalGivenAmt.value = 0.0;
            totalPendingAmt.value = 0.0;
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustReport ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
