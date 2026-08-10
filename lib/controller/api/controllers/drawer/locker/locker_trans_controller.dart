import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/locker/locker_trans_service.dart';
import 'package:rukmini/modal/drawer/locker/locker_trans_modal.dart';

class LockerTransController extends GetxController {
  final LockerTransServices _services = LockerTransServices();
  var isLoading = false.obs;
  var lockerTransList = <LockerTransData>[].obs;

  Future<http.Response?> getLockerTransList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.lockerListTransApi();

      if (kDebugMode) {
        print('LockerListTrans Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          final model = LockerTransModal.fromJson(decoded);
          lockerTransList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('LockerListTrans Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
