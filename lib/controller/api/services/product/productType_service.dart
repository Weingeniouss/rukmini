// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../../view/utils/app_constants.dart';

class ProductTypeServices {
  final String url = AppUrl.productTypeList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> productTypeApi() async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final uri = Uri.parse(url);

    if (kDebugMode) {
      print('--- ProductType API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- ProductType API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
