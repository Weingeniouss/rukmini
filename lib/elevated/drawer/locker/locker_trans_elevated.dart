import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_trans_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_trans_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<LockerTransModal?> getLockerTransList() async {
  final LockerTransController controller = Get.put(LockerTransController());

  final http.Response? response = await controller.getLockerTransList();

  if (response != null) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final model = LockerTransModal.fromJson(decoded);
        if (model.status == false) {
          ToastificationError.Error(model.message ?? 'Failed to load locker transactions');
        }
        return model;
      }
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
