// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/girvi/giriviDetail_services.dart';
import 'package:rukmini/modal/drawer/home/girvi/girvi_detail_modal.dart';

class GiriviDetailController extends GetxController {
  final GiriviDetailServices _giriviDetailServices = GiriviDetailServices();
  var isLoading = false.obs;
  var giriviDetailData = GiriviDetailModal().obs;

  Future<http.Response?> getGiriviDetail({
    String? timezone,
    String? girviId,
  }) async {
    try {
      isLoading.value = true;

      final http.Response response = await _giriviDetailServices.giriviDetailApi(
        timezone: timezone,
        girviId: girviId,
      );

      if (kDebugMode) {
        print('GiriviDetail Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          giriviDetailData.value = GiriviDetailModal.fromJson(decoded);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('GiriviDetail Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
