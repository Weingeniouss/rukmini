// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/api/controllers/metal/metal_Controller.dart';
import '../../modal/metal/metalList_Modal.dart';
import 'package:rukmini/view/utils/app_String.dart';
import '../../view/utils/widget/pop.dart';

Future<MetalListModal?> getMetalList() async {
  final MetalController metalController = Get.put(MetalController());
  final http.Response? response = await metalController.getMetalList();

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final metalListModal = MetalListModal.fromJson(decoded);
      if (response.statusCode == 200) {
        if (metalListModal.status == true) {
          return metalListModal;
        } else {
          ToastificationError.Error(
              metalListModal.message ?? AppString.failedToLoadMetalList);
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${response.statusCode}');
      }
    } else {
      ToastificationError.Error('Invalid server response format');
    }
  }
  return null;
}
