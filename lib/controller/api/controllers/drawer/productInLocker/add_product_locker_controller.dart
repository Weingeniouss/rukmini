import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/productInLocker/add_product_locker_service.dart';

class AddProductLockerController extends GetxController {
  final AddProductLockerService _service = AddProductLockerService();
  var isLoading = false.obs;

  Future<http.Response?> addProductLocker({
    required String lockerId,
    required String interestRate,
    required String lockerProdDel,
    required String lockerCode,
    required String lockerDate,
  }) async {
    try {
      isLoading.value = true;
      final http.Response response = await _service.addProductLockerApi(
        lockerId: lockerId,
        interestRate: interestRate,
        lockerProdDel: lockerProdDel,
        lockerCode: lockerCode,
        lockerDate: lockerDate,
      );

      if (kDebugMode) {
        print('AddProductLocker Response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('AddProductLocker Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
