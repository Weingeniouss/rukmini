// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/metal/metalList_service.dart';
import 'package:rukmini/modal/metal/metalList_Modal.dart';

class MetalController extends GetxController {
  final MetalListServices _metalListServices = MetalListServices();
  var isLoading = false.obs;
  var metalList = <MetalData>[].obs;
  var metalListData = MetalListModal().obs;

  Future<http.Response?> getMetalList() async {
    try {
      isLoading.value = true;
      final http.Response response = await _metalListServices.metalListApi();

      if (kDebugMode) {
        print('MetalList Response: ${response.body}');
      }

      if (response.statusCode == 200) {
        String body = response.body;
        if (body.contains('{') && body.contains('}')) {
          body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
        }
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final model = MetalListModal.fromJson(decoded);
          metalListData.value = model;
          metalList.assignAll(model.data ?? []);
        }
      }
      return response;
    } catch (e) {
      if (kDebugMode) print('MetalList Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
