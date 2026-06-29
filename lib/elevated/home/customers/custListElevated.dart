// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../controller/api/controllers/home/customers/custList_Controller.dart';
import '../../../modal/home/customer/customer_list_model.dart';
import '../../../view/utils/widget/pop.dart';

Future<CustomerListModel?> getCustList({bool isRefresh = false}) async {
  final CustListController custListController = Get.put(CustListController());
  final http.Response? response =
      await custListController.custList(isRefresh: isRefresh);

  if (response != null) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final customerListModel = CustomerListModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (customerListModel.status == true) {
          return customerListModel;
        } else {
          ToastificationError.Error(
              customerListModel.message ?? 'Failed to load customer list');
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
