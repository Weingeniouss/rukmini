// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../view/utils/app_String.dart';
import '../../../../view/utils/app_URL.dart';
import '../../../../view/utils/app_constants.dart';

class MetalRemoveServices {
  final String url = AppUrl.metalRemove;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> metalRemoveApi({required String metalId}) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, String> queryParameters = {
      AppString.metal_Id: metalId,
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- MetalRemove API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- MetalRemove API Request ---');
    }

    return await http.get(uri, headers: headers);
  }
}
