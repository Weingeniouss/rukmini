// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custRemove_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/remove_customer_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<RemoveCustomerModel?> postRemoveCustomer({
  required String custId,
}) async {
  final CustRemoveController removeController = Get.put(CustRemoveController());
  final http.Response? response = await removeController.removeCustomer(
    custId: custId,
  );

  if (response != null) {
    if (kDebugMode) {
      print('--- Customer Remove API Response ---');
      print('Body: ${response.body}');
      print('--- Customer Remove API Response ---');
    }
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final removeModel = RemoveCustomerModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (removeModel.status == true) {
          ToastificationSuccess.Success(
            removeModel.message ?? AppString.customerremovededsuccessfully,
          );
          return removeModel;
        } else {
          ToastificationError.Error(
            removeModel.message ?? AppString.failedtoremovecustomer,
          );
        }
      } else {
        ToastificationError.Error('${removeModel.message}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
