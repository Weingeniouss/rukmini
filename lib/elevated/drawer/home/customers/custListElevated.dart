// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/local/localDatabase.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import '../../../../modal/drawer/home/customer/customer_list_model.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CustomerListModel?> getCustList({
  bool isRefresh = false,
  String? search,
  String? fromDate,
  String? toDate,
}) async {
  final CustListController custListController = Get.put(CustListController());
  final http.Response? response = await custListController.custList(
    isRefresh: isRefresh,
    search: search,
    fromDate: fromDate,
    toDate: toDate,
  );

  if (response != null) {
    String body = response.body;
    // If the response contains HTML (PHP Errors), extract only the JSON part
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final customerListModel = CustomerListModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (customerListModel.status == true) {
          return customerListModel;
        } else {
          ToastificationError.Error(
            customerListModel.message ?? AppString.noCustomersFound,
          );
        }
      } else if (response.statusCode == 401) {
        await LocalDatabase.handleUnauthorized();
      } else if (response.statusCode == 404) {
        // Suppress error for 404 (Not Found) during search
      } else {
        ToastificationError.Error(
          '${AppString.serverError}${response.statusCode}',
        );
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
