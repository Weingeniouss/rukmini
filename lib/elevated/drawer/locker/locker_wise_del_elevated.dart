import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/locker/locker_wise_del_controller.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<LockerWiseDelModal?> getLockerWiseDel({
  required String lockerId,
  String? page,
  String? search,
}) async {
  final LockerWiseDelController controller = Get.put(LockerWiseDelController());

  final http.Response? response = await controller.getLockerWiseDel(
    lockerId: lockerId,
    page: page,
    search: search,
  );

  if (response != null) {
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final model = LockerWiseDelModal.fromJson(decoded);
        if (model.status == false) {
          ToastificationError.Error(model.message ?? 'Failed to load locker details');
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
