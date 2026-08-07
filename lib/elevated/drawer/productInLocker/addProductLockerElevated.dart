import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/add_product_locker_controller.dart';
import 'package:rukmini/modal/drawer/productInLocker/add_product_locker_model.dart';
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
          ToastificationSuccess.Success(model.message ?? 'Locker changed successfully');
        } else {
          ToastificationError.Error(model.message ?? 'Failed to change locker');
        }
        return model;
      }
    } else {
      ToastificationError.Error('Server Error: ${response.statusCode}');
    }
  } else {
    ToastificationError.Error('Invalid server response format');
  }
  return null;
}
