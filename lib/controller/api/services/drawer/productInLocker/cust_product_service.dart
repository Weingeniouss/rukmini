import 'package:flutter/foundation.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:http/http.dart' as http;
import '../../../../../view/utils/app_constants.dart';

class CustProductService {
  final String url = AppUrl.productInLocker;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custProductApi() async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    if (kDebugMode) {
      print('--- CustProduct API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('--- CustProduct API Request ---');
    }

    return await http.get(
      Uri.parse(url),
      headers: headers,
    );
  }
}
