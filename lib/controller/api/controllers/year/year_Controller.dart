import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/year/year_services.dart';
import 'package:rukmini/modal/year/year_modal.dart';

class YearController extends GetxController {
  final YearServices _yearServices = YearServices();
  var isLoading = false.obs;
  var yearData = YearModel().obs;
  var yearList = <YearData>[].obs;

  Future<http.Response?> getYearList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _yearServices.yearListApi();

      if (kDebugMode) {
        print('YearList Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = YearModel.fromJson(decoded);
          yearData.value = model;
          yearList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('YearList Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
