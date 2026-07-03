// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../controller/api/controllers/home/customers/custDetail_Controller.dart';
import '../../../modal/home/customer/customer_detail_model.dart';
import '../../../view/utils/widget/pop.dart';

Future<CustomerDetailModel?> getCustDetail({String? custId}) async {
  final CustdetailController custDetailController = Get.put(CustdetailController());
  final http.Response? response =
      await custDetailController.fetchCustDetail(custId: custId);

  if (response != null) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final customerDetailModel = CustomerDetailModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (customerDetailModel.status == true) {
          return customerDetailModel;
        } else {
          ToastificationError.Error(
              customerDetailModel.message ?? 'Failed to load customer details');
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
