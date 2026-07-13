// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class CustRemoveServices {
  final String url = AppUrl.custRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custRemoveApi({required String custId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.cusid: custId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- Customer Remove API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- Customer Remove API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
