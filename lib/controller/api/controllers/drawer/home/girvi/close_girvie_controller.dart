import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/girvi/close_girvie_services.dart';

class CloseGirvieController extends GetxController {
  final CloseGirvieServices _closeGirvieServices = CloseGirvieServices();
  var isLoading = false.obs;

  Future<http.Response?> closeGirvie({
    required String girviId,
  }) async {
    try {
      isLoading.value = true;

      final http.Response response = await _closeGirvieServices.closeGirvieApi(
        girviId: girviId,
      );

      if (kDebugMode) {
        print('Close Girvie Response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('Close Girvie Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
