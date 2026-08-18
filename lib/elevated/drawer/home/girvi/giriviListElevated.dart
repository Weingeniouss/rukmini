// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/local/localDatabase.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviList_Controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_list_model.dart';

Future<GirviListModel?> getGiriviList({
  bool isRefresh = false,
  bool isLoadMoreAction = false,
  String? search,
  String? filterType,
  String? yearId,
  String? formDate,
  String? toDate,
}) async {
  final GiriviListController giriviListController = Get.put(
    GiriviListController(),
  );

  final http.Response? response = await giriviListController.getGiriviList(
    isRefresh: isRefresh,
    isLoadMoreAction: isLoadMoreAction,
    search: search,
    filterType: filterType,
    yearId: yearId,
    formDate: formDate,
    toDate: toDate,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final model = GirviListModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) return model;
        ToastificationError.Error(model.message ?? AppString.failedToLoadList);
      } else if (response.statusCode == 401) {
        await LocalDatabase.handleUnauthorized();
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
