// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_string.dart';
import '../../../../../../view/utils/app_url.dart';
import '../../../../../../view/utils/app_constants.dart';

class CustListServices {
  final String url = AppUrl.custList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custListApi({
    String? timezone,
    String? search,
    String? page,
    String? fromDate,
    String? toDate,
  }) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
    };

    final Map<String, String> queryParameters = {
      AppString.timezonePera: timezone ?? '',
      AppString.searchPera: search ?? '',
      AppString.pagePera: page ?? '1',
      AppString.FormDate: fromDate ?? '',
      AppString.ToDate: toDate ?? '',
    };

    final uri = Uri.parse(url).replace(queryParameters: queryParameters);

    if (kDebugMode) {
      print('--- CustomerList API Request ---');
      print('URL: $uri');
      print('Headers: $headers');
      print('--- CustomerList API Request ---');
    }
    return await http.get(uri, headers: headers);
  }
}
