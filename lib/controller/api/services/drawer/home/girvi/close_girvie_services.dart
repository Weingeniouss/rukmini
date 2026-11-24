import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_string.dart';
import 'package:rukmini/view/utils/app_url.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class CloseGirvieServices {
  final String url = AppUrl.closeGirvie;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> closeGirvieApi({
    required String girviId,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
    };

    final Map<String, String> queryParams = {
      AppString.girviId_body: girviId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    if (kDebugMode) {
      print('--- Close Girvie API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- Close Girvie API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
