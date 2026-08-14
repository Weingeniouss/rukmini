// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/controllers/drawer/home/customers/custDetail_Controller.dart';
import '../../../../modal/drawer/home/customer/customer_detail_model.dart';
import '../../../../view/utils/widget/pop.dart';

Future<CustomerDetailModel?> getCustDetail({String? custId}) async {
  final CustdetailController custDetailController = Get.put(CustdetailController());
  final http.Response? response =
      await custDetailController.fetchCustDetail(custId: custId);

  if (response != null) {
    String body = response.body;
    // If the response contains HTML (PHP Errors), extract only the JSON part
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final customerDetailModel = CustomerDetailModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (customerDetailModel.status == true) {
          return customerDetailModel;
        } else {
          ToastificationError.Error(
              customerDetailModel.message ?? AppString.noDetailsFound);
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
