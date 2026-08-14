// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';
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
      final model = YearModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) return model;
        ToastificationError.Error(model.message ?? AppString.failedToLoadList);
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
      return model;
    }
  } else {
    ToastificationError.Error(AppString.invalidserverresponseformat);
  }
  return null;
}
