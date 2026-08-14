// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class ProductTypeRemoveServices {
  final String url = AppUrl.productTypeRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> productTypeRemoveApi({required String productTypeId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.productType_Id: productTypeId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- ProductTypeRemove API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- ProductTypeRemove API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
