// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviDetail_Controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<GiriviDetailModal?> getGiriviDetail({
  String? timezone,
  String? girviId,
}) async {
  final GiriviDetailController giriviDetailController = Get.put(
    GiriviDetailController(),
  );

  final http.Response? response = await giriviDetailController.getGiriviDetail(
    timezone: timezone,
    girviId: girviId,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final model = GiriviDetailModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) {
          return model;
        } else {
          ToastificationError.Error(
            model.message ?? AppString.failedToLoadList,
          );
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
