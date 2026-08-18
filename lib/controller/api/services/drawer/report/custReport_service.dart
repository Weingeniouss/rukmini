// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../../view/utils/app_String.dart';
import '../../../../../view/utils/app_URL.dart';
import '../../../../../view/utils/app_constants.dart';

class CustReportServices {
  final String url = AppUrl.customerReport;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> custReportApi({
    String? timezone,
    String? search,
    String? fromDate,
    String? toDate,
  }) async {
    final Map<String, String> headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, dynamic> body = {
      AppString.timezone: timezone ?? '',
      AppString.Search: search ?? '',
      AppString.FormDate: fromDate ?? '',
      AppString.ToDate: toDate ?? '',
    };

    if (kDebugMode) {
      print('--- CustomerReport API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');
      print('--- CustomerReport API Request ---');
    }
    return await http.post(Uri.parse(url), headers: headers, body: body);
  }
}
