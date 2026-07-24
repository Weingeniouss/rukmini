import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/remove_girvie_controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/remove_girvie_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<RemoveGirvie?> postRemoveGirvie({
  required String girviId,
}) async {
  final RemoveGirvieController removeGirvieController = Get.put(
    RemoveGirvieController(),
  );

  final http.Response? response = await removeGirvieController.removeGirvie(
    girviId: girviId,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final removeGirvieModel = RemoveGirvie.fromJson(decoded);
      if (response.statusCode == 200) {
        if (removeGirvieModel.status == true) {
          ToastificationSuccess.Success(
            removeGirvieModel.message ?? AppString.giriviremovedsuccessfully,
          );
          return removeGirvieModel;
        } else {
          ToastificationError.Error(
            removeGirvieModel.message ?? AppString.failedtoremovegirvi,
          );
        }
      } else {
        ToastificationError.Error('${removeGirvieModel.message}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
