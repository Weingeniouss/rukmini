import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class LockerDetailServices {
  final String url = AppUrl.lockerDetail;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerDetailApi({
    required String lockerId,
    required String code,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final queryParameters = {
      'LockerId': lockerId,
      'Code': code,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- LockerDetail API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- LockerDetail API Request ---');
    }

    return await http.get(
      uri,
      headers: headers,
    );
  }
}
