import 'package:rukmini/view/utils/app_String.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/services/drawer/home/girvi/remove_girvie_services.dart';

class RemoveGirvieController extends GetxController {
  final RemoveGirvieServices _removeGirvieServices = RemoveGirvieServices();
  var isLoading = false.obs;

  Future<http.Response?> removeGirvie({
    required String girviId,
  }) async {
    try {
      isLoading.value = true;

      final http.Response response = await _removeGirvieServices.removeGirvieApi(
        girviId: girviId,
      );

      if (kDebugMode) {
        print('Remove Girvie ${AppString.responseLog}${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('Remove Girvie ${AppString.errorLog}$e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
