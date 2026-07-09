// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/customres/custDetail_service.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_detail_model.dart';

class CustdetailController extends GetxController {
  final CustDetailServices _custDetailServices = CustDetailServices();
  var isLoading = false.obs;
  var custDetailData = CustomerDetailModel().obs;

  Future<http.Response?> fetchCustDetail({String? custId}) async {
    try {
      isLoading.value = true;
      final http.Response response = await _custDetailServices.custDetailApi(
        cusid: custId,
      );
      if (kDebugMode) {
        print('CustDetail Response: ${response.body}');
      }
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          custDetailData.value = CustomerDetailModel.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustDetail Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
