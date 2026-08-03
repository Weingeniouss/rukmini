import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class YearRemoveService {
  final String url = AppUrl.yearsRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> yearRemoveApi({required String yearId}) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final queryParameters = {
      'YearId': yearId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- YearRemove API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- YearRemove API Request ---');
    }

    return await http.get(
      uri,
      headers: headers,
    );
  }
}
