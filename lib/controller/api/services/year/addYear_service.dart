import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/app_constants.dart';

class AddYearService {
  final String url = AppUrl.yearAdd;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> addYearApi({
    required String title,
    required String fromDate,
    required String toDate,
    String? isCurrent,
    String? yearId,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final body = {
      'Title': title,
      'FormDate': fromDate,
      'ToDate': toDate,
      'IsCurrent': isCurrent ?? "0",
    };
    
    if (yearId != null) {
      body['YearId'] = yearId;
    }

    if (kDebugMode) {
      print('--- AddYear API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');
      print('--- AddYear API Request ---');
    }

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }
}
