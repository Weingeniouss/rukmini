// ignore_for_file: file_names

import 'package:rukmini/view/utils/app_String.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/all_master/customer_type_master/customerType_service.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_master_modal.dart';

class CustomerTypeController extends GetxController {
  final CustomerTypeServices _services = CustomerTypeServices();
  var isLoading = false.obs;
  var customerTypeList = <CustomerTypeData>[].obs;

  Future<http.Response?> getCustomerTypeList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.customerTypeListApi();
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = CustomerTypeMaster.fromJson(decoded);
          customerTypeList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustomerType ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
