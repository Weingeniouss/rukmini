import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/controller/api/controllers/drawer/home/girvi/close_girvie_controller.dart';
import 'package:rukmini/modal/drawer/home/girvi/close_girvie_model.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/widget/pop.dart';

Future<CloseGirvie?> postCloseGirvie({
  required String girviId,
}) async {
  final CloseGirvieController closeGirvieController = Get.put(
    CloseGirvieController(),
  );

  final http.Response? response = await closeGirvieController.closeGirvie(
    girviId: girviId,
  );

  if (response != null) {
    String body = response.body;
    if (body.contains('{') && body.contains('}')) {
      body = body.substring(body.indexOf('{'), body.lastIndexOf('}') + 1);
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      final closeGirvieModel = CloseGirvie.fromJson(decoded);
      if (response.statusCode == 200) {
        if (closeGirvieModel.status == true) {
          ToastificationSuccess.Success(
            closeGirvieModel.message ?? AppString.giriviclosedsuccessfully,
          );
          return closeGirvieModel;
        } else {
          ToastificationError.Error(
            closeGirvieModel.message ?? AppString.failedtoclosegirvi,
          );
        }
      } else {
        ToastificationError.Error('${closeGirvieModel.message}');
      }
    } else {
      ToastificationError.Error(AppString.invalidserverresponseformat);
    }
  }
  return null;
}
