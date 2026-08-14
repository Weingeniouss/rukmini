// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../controller/api/services/drawer/all_master/locker_master/lockerRemove_service.dart';
import '../../../../modal/drawer/allMaster/locker_master/locker_remove_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<LockerRemoveModal?> postLockerRemove({required String lockerId}) async {
  final LockerRemoveServices service = LockerRemoveServices();
  final http.Response response = await service.lockerRemoveApi(lockerId: lockerId);
  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = LockerRemoveModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? 'Locker removed successfully');
        return model;
      }
      ToastificationError.Error(model.message ?? 'Failed to remove locker');
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  }
  return null;
}
