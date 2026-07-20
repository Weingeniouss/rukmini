import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class YearServices {
  final String url = AppUrl.yearList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> yearListApi() async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    if (kDebugMode) {
      print('--- YearList API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('--- YearList API Request ---');
    }

    return await http.get(
      Uri.parse(url),
      headers: headers,
    );
  }
}
