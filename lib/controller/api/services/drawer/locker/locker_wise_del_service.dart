import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class LockerWiseDelServices {
  final String url = AppUrl.lockerWiseDel;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerWiseDelApi({
    required String lockerId,
    String? page,
    String? search,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final queryParameters = {
      'LockerId': lockerId,
      'Page': page ?? '1',
      'Search': search ?? '',
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- LockerWiseDel API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- LockerWiseDel API Request ---');
    }

    return await http.get(
      uri,
      headers: headers,
    );
  }
}
