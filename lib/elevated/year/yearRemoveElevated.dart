// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../controller/api/controllers/year/yearRemove_Controller.dart';
import '../../modal/year/yearRemove_modal.dart';
import '../../view/utils/widget/pop.dart';

Future<YearRemoveModal?> postYearRemove({required String yearId}) async {
  final YearRemoveController removeController = Get.put(YearRemoveController());

  final http.Response? response = await removeController.removeYear(yearId: yearId);

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final model = YearRemoveModal.fromJson(decoded);
      if (model.status == true) {
        ToastificationSuccess.Success(model.message?.toString() ?? 'Year removed successfully');
      } else {
        ToastificationError.Error(model.message?.toString() ?? AppString.failedToRemoveYear);
      }
      return model;
    }
  }
  return null;
}
