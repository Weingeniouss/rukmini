// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import '../../../../controller/api/services/drawer/all_master/locker_master/lockerAdd_service.dart';
import '../../../../modal/drawer/allMaster/locker_master/locker_add_modal.dart';
import '../../../../view/utils/widget/pop.dart';

Future<LockerAddModal?> postLockerAdd({
  required String lockerCode,
  required String comName,
  required String comAddress,
  required String personName,
  required String personPhone,
  required String interestRate,
  required String isDefault,
  String? lockerId,
}) async {
  final LockerAddServices service = LockerAddServices();
  final http.Response response = await service.lockerAddApi(
    lockerCode: lockerCode,
    comName: comName,
    comAddress: comAddress,
    personName: personName,
    personPhone: personPhone,
    interestRate: interestRate,
    isDefault: isDefault,
    lockerId: lockerId,
  );

  final decoded = jsonDecode(response.body);
  if (decoded is Map<String, dynamic>) {
    final model = LockerAddModal.fromJson(decoded);
    if (response.statusCode == 200) {
      if (model.status == true) {
        ToastificationSuccess.Success(model.message ?? AppString.lockerDetailsSavedSuccessfully);
        return model;
      }
      ToastificationError.Error(model.message ?? AppString.failedToSaveLocker);
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  }
  return null;
}
