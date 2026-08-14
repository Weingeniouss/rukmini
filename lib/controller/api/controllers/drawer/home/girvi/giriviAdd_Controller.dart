// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/controller/api/services/drawer/home/girvi/giriviadd_services.dart';

class GiriviAddController extends GetxController {
  final GiriviAddServices _giriviAddServices = GiriviAddServices();
  var isLoading = false.obs;

  Future<http.Response?> addGirivi({
    String? custId,
    String? girviDate,
    String? givenMonth,
    String? dueDate,
    String? interest,
    String? givenAmt,
    String? address,
    String? productDel,
    XFile? image_i,
  }) async {
    try {
      isLoading.value = true;

      final http.Response response = await _giriviAddServices.giriviAddtApi(
        custId: custId,
        girviDate: girviDate,
        givenMonth: givenMonth,
        dueDate: dueDate,
        interest: interest,
        givenAmt: givenAmt,
        address: address,
        productDel: productDel,
        image_i: image_i,
      );

      if (kDebugMode) {
        print('GiriviAdd Response: ${response.body}');
      }

      return response;
    } catch (e) {
      if (kDebugMode) print('GiriviAdd Error: $e');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
