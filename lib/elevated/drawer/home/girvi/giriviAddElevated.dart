// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/giriviAdd_Controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/girivi_add_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<GiriviAddModel?> postAddGirivi({
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
  final GiriviAddController giriviAddController = Get.put(
    GiriviAddController(),
  );

  final http.Response? response = await giriviAddController.addGirivi(
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

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final giriviAddModel = GiriviAddModel.fromJson(decoded);
      if (response.statusCode == 200) {
        if (giriviAddModel.status == true) {
          ToastificationSuccess.Success(
            giriviAddModel.message ?? AppString.giriviaddedsuccessfully,
          );
          return giriviAddModel;
        } else {
          ToastificationError.Error(
            giriviAddModel.message ?? AppString.failedtoaddgirivi,
          );
        }
      } else {
        ToastificationError.Error('${AppString.serverError}${giriviAddModel.message}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
