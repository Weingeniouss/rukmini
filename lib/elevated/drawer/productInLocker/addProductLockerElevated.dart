// ignore_for_file: file_names

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/add_product_locker_controller.dart';
import 'package:rukmini/modal/drawer/productInLocker/add_product_locker_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<AddProductLockerModel?> postAddProductLocker({
  required String lockerId,
  required String interestRate,
  required String lockerProdDel,
  required String lockerCode,
  required String lockerDate,
}) async {
  final AddProductLockerController controller = Get.put(AddProductLockerController());

  final http.Response? response = await controller.addProductLocker(
    lockerId: lockerId,
    interestRate: interestRate,
    lockerProdDel: lockerProdDel,
    lockerCode: lockerCode,
    lockerDate: lockerDate,
  );

  if (response != null) {
    if (response.statusCode == 200) {
      String body = response.body;
      if (body.contains('{') && body.contains('}')) {
        body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
      }

      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final model = AddProductLockerModel.fromJson(decoded);
        if (model.status == true) {
          ToastificationSuccess.Success(model.message ?? AppString.lockerChangedSuccessfully);
        } else {
          ToastificationError.Error(model.message ?? AppString.failedToChangeLocker);
        }
        return model;
      }
    } else {
      ToastificationError.Error('${AppString.serverError}${response.statusCode}');
    }
  } else {
    ToastificationError.Error(AppString.invalidserverresponseformat);
  }
  return null;
}
