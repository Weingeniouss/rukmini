import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/year/addYear_Controller.dart';
import 'package:rukmini/modal/year/addYear_modal.dart';

Future<AddYearModal?> postAddYear({
  required String title,
  required String fromDate,
  required String toDate,
  String? isCurrent,
  String? yearId,
}) async {
  final AddYearController addYearController = Get.put(AddYearController());

  final http.Response? response = await addYearController.addYear(
    title: title,
    fromDate: fromDate,
    toDate: toDate,
    isCurrent: isCurrent,
    yearId: yearId,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return AddYearModal.fromJson(decoded);
    }
  }
  return null;
}
