import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class GiriviDetailServices {
  final String url = AppUrl.girviDetail;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> giriviDetailApi({
    String? timezone,
    String? girviId,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParams = {
      AppString.timezone: timezone ?? '',
      AppString.girviId_body: girviId ?? '',
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    if (kDebugMode) {
      print('--- GiriviDetail API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- GiriviDetail API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
