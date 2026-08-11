import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/locker/locker_detail_service.dart';
import 'package:rukmini/modal/drawer/locker/locker_detail_modal.dart';

class LockerDetailController extends GetxController {
  final LockerDetailServices _services = LockerDetailServices();
  var isLoading = false.obs;
  var lockerDetailData = LockerDetailModal().obs;

  Future<http.Response?> getLockerDetail({
    required String lockerId,
    required String code,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _services.lockerDetailApi(
        lockerId: lockerId,
        code: code,
      );

      if (kDebugMode) {
        print('LockerDetail Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          lockerDetailData.value = LockerDetailModal.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('LockerDetail Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
