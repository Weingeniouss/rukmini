// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/year/year_Controller.dart';
import 'package:rukmini/modal/year/year_modal.dart';

Future<YearModel?> getYearList() async {
  final YearController yearController = Get.put(YearController());

  final http.Response? response = await yearController.getYearList();

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return YearModel.fromJson(decoded);
    }
  }
  return null;
}
