// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/home/customres/custList_service.dart';
import 'package:rukmini/modal/home/customer/customer_list_model.dart';

class CustListController extends GetxController {
  final CustListServices cuslistServices = CustListServices();
  var isLoading = false.obs;
  var isMoreLoading = false.obs;
  var currentPage = 1;
  var hasMoreData = true.obs;
  
  var customerListData = CustomerListModel().obs;
  var customers = <CustomerData>[].obs;

  Future<http.Response?> custList({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreData.value = true;
    }

    if (!hasMoreData.value) return null;

    try {
      if (currentPage == 1) {
        isLoading.value = true;
      } else {
        isMoreLoading.value = true;
      }

      final http.Response response = await cuslistServices.custListApi(
        page: currentPage.toString(),
      );

      if (kDebugMode) {
        print('CustList Response (Page $currentPage): ${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final newData = CustomerListModel.fromJson(decoded);
          customerListData.value = newData;

          if (currentPage == 1) {
            customers.assignAll(newData.data ?? []);
          } else {
            customers.addAll(newData.data ?? []);
          }

          // Check if we've reached the end
          if (newData.data == null || newData.data!.isEmpty) {
            hasMoreData.value = false;
          } else {
            currentPage++;
          }
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('CustList Error: $e');
      return null;
    } finally {
      isLoading.value = false;
      isMoreLoading.value = false;
    }
  }
}
