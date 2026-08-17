import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/controller/api/services/drawer/locker/locker_wise_del_service.dart';
import 'package:rukmini/modal/drawer/locker/locker_wise_del_modal.dart';

class LockerWiseDelController extends GetxController {
  final LockerWiseDelServices _services = LockerWiseDelServices();
  var isLoading = false.obs;
  var lockerWiseList = <LockerWiseData>[].obs;

  Future<http.Response?> getLockerWiseDel({
    required String lockerId,
    String? page,
    String? search,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.lockerWiseDelApi(
        lockerId: lockerId,
        page: page,
        search: search,
      );

      if (kDebugMode) {
        print('LockerWiseDel ${AppString.responseLog}${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = LockerWiseDelModal.fromJson(decoded);
          lockerWiseList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('LockerWiseDel ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
