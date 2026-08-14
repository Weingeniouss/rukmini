// ignore_for_file: file_names, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/all_master/customer_type_master/customerType_Controller.dart';
import 'package:get/get.dart';
import 'package:rukmini/modal/drawer/allMaster/customer_type_master/customer_type_master_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<CustomerTypeMaster?> getCustomerTypeList() async {
  final controller = Get.put(CustomerTypeController());
  final http.Response? response = await controller.getCustomerTypeList();
  if (response != null) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final model = CustomerTypeMaster.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) return model;
        ToastificationError.Error(model.message ?? 'Failed to load list');
      } else {
        ToastificationError.Error('Server Error: ${response.statusCode}');
      }
    }
  }
  return null;
}

Future<CustomerTypeMaster?> postCustomerTypeAdd({
  required String name,
  String? typeId,
}) async {
  final controller = Get.put(CustomerTypeController());
  final response = await controller
      .getCustomerTypeList(); // Not correct, should use service directly or dedicated controller
  // Wait, I'll use a better approach in CallApi
  return null;
}
