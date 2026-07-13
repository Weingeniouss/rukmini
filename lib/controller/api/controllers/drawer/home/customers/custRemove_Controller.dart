// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/customres/custRemove_service.dart';

class CustRemoveController extends GetxController {
  final CustRemoveServices _custRemoveServices = CustRemoveServices();
  var isLoading = false.obs;

  Future<http.Response?> removeCustomer({required String custId}) async {
    try {
      isLoading.value = true;
      final http.Response response = await _custRemoveServices.custRemoveApi(
        custId: custId,
      );
      return response;
    } catch (e) {
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
