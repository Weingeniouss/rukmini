import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/year/addYear_service.dart';

class AddYearController extends GetxController {
  final AddYearService _addYearService = AddYearService();
  var isLoading = false.obs;

  Future<http.Response?> addYear({
    required String title,
    required String fromDate,
    required String toDate,
    String? isCurrent,
    String? yearId,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _addYearService.addYearApi(
        title: title,
        fromDate: fromDate,
        toDate: toDate,
        isCurrent: isCurrent,
        yearId: yearId,
      );

      if (kDebugMode) {
        print('AddYear Response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('AddYear Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
