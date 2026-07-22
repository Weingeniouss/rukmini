import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_constants.dart';

class GiriviAddServices {
  final String url = AppUrl.girviAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> giriviAddtApi({
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
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll({
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    });

    request.fields[AppString.custId_body] = custId ?? '';
    request.fields[AppString.girviDate_body] = girviDate ?? '';
    request.fields[AppString.givenMonth_body] = givenMonth ?? '';
    request.fields[AppString.dueDate_body] = dueDate ?? '';
    request.fields[AppString.interest_body] = interest ?? '';
    request.fields[AppString.givenAmt_body] = givenAmt ?? '';
    request.fields[AppString.address_body] = address ?? '';
    request.fields[AppString.productDel_body] = productDel ?? '';

    if (image_i != null) {
      request.files.add(
        await http.MultipartFile.fromPath(AppString.image_body, image_i.path),
      );
    }

    if (kDebugMode) {
      print('--- GiriviAdd Multipart Request ---');
      print('URL: $url');
      print('Fields: ${request.fields}');
      print('--- GiriviAdd Multipart Request ---');
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
