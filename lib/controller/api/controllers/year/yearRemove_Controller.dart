import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/year/yearRemove_service.dart';

class YearRemoveController extends GetxController {
  final YearRemoveService _yearRemoveService = YearRemoveService();
  var isLoading = false.obs;

  Future<http.Response?> removeYear({required String yearId}) async {
    try {
      isLoading.value = true;
      final http.Response response = await _yearRemoveService.yearRemoveApi(yearId: yearId);

      if (kDebugMode) {
        print('YearRemove Response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('YearRemove Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
