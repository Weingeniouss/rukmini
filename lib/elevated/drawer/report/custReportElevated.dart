// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/local/localDatabase.dart';
import '../../../view/utils/app_String.dart';
import '../../../view/utils/widget/pop.dart';
import '../../../modal/drawer/report/customer_report_model.dart';
import '../../../controller/api/controllers/drawer/report/custReport_Controller.dart';

Future<CustomerReportModel?> getCustReport({
  String? search,
  String? fromDate,
  String? toDate,
}) async {
  final CustReportController controller = Get.put(CustReportController());
  final http.Response? response = await controller.getCustReport(
    search: search,
    fromDate: fromDate,
    toDate: toDate,
  );

  if (response != null) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final model = CustomerReportModel.fromJson(decoded);
        if (model.status == true) {
          return model;
        } else {
          ToastificationError.Error(model.message ?? AppString.noDataFound);
        }
      }
    } else if (response.statusCode == 401) {
      await LocalDatabase.handleUnauthorized();
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  }
  return null;
}
