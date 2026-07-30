import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class CategoryServices {
  final String url = AppUrl.categoryList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> categoryApi() async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final uri = Uri.parse(url);

    if (kDebugMode) {
      print('--- Category API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- Category API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
