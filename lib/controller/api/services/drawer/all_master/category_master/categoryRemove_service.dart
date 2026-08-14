// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_String.dart';
import '../../../../../../view/utils/app_URL.dart';
import '../../../../../../view/utils/app_constants.dart';

class CategoryRemoveServices {
  final String url = AppUrl.categoryRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> categoryRemoveApi({required String categoryId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.category_Id: categoryId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- CategoryRemove API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- CategoryRemove API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
