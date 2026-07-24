import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class RemoveGirvieServices {
  final String url = AppUrl.removeGirvie;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> removeGirvieApi({
    required String girviId,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParams = {
      AppString.girviId_body: girviId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    if (kDebugMode) {
      print('--- Remove Girvie API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- Remove Girvie API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
