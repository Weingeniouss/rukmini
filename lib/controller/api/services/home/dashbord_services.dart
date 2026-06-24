import 'package:flutter/foundation.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_constants.dart';
import '../../../../view/utils/app_URL.dart';
import 'package:http/http.dart' as http;

class DashbordServices {
  final String url = AppUrl.dashboard;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> dashbordApi() async {
    final queryParameters = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };
    
    if (kDebugMode) {
      print('--- Dashboard API Request ---');
      print('URL: $url');
      print('queryParameters: $queryParameters');
      print('--- Dashboard API Request ---');
    }

    return await http.get(Uri.parse(url), headers: queryParameters);
  }
}
