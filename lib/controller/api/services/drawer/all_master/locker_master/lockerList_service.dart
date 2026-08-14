// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class LockerListServices {
  final String url = AppUrl.lockerList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> lockerListApi() async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    final uri = Uri.parse(url);
    if (kDebugMode) {
      print('--- Locker List API Request ---');
      print('URL: $uri');
      print('--- Locker List API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
