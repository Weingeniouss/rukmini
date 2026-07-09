// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_constants.dart';

class CustDetailServices {
  final String url = AppUrl.custDetail;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custDetailApi({String? cusid}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {AppString.cusid: cusid ?? '1'};

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- CustomerList API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- CustomerList API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
