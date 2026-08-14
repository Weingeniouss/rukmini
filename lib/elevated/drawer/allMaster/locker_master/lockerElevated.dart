// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/modal/drawer/allMaster/locker_master/locker_master_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<LockerMasterModal?> getLockerList() async {
  final controller = Get.put(LockerListController());
  final http.Response? response = await controller.getLockerList();
  if (response != null) {
    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      final model = LockerMasterModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (model.status == true) return model;
        ToastificationError.Error(model.message ?? 'Failed to load list');
      } else {
        ToastificationError.Error('Server Error: ${response.statusCode}');
      }
    }
  }
  return null;
}
