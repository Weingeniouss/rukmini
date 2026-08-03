import 'dart:convert';
import 'package:http/http.dart' as http;
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
        ToastificationSuccess.Success(model.message ?? 'Locker details saved successfully');
        return model;
      }
      ToastificationError.Error(model.message ?? 'Failed to save locker');
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  }
  return null;
}
