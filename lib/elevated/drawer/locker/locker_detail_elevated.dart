import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_detail_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_detail_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<LockerDetailModal?> getLockerDetail({
  required String lockerId,
  required String code,
}) async {
  final LockerDetailController controller = Get.put(LockerDetailController());

  final http.Response? response = await controller.getLockerDetail(
    lockerId: lockerId,
    code: code,
  );

  if (response != null) {
    if (response.statusCode == 200) {
      String body = response.body;
      if (body.contains('{') && body.contains('}')) {
        body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
      }

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final model = LockerDetailModal.fromJson(decoded);
        if (model.status == false) {
          ToastificationError.Error(model.message?.toString() ?? 'Failed to load locker details');
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
