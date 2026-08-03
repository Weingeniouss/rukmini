import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class LockerRemoveServices {
  final String url = AppUrl.lockerRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerRemoveApi({required String lockerId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    final Map<String, String> queryParameters = {
      AppString.locker_Id: lockerId,
    };
    final uri = Uri.parse(url).replace(queryParameters: queryParameters);
    if (kDebugMode) {
      print('--- Locker Remove API Request ---');
      print('URL: $uri');
      print('--- Locker Remove API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
