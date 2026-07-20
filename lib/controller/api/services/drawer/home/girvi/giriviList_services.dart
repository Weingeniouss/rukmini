import 'package:flutter/foundation.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:http/http.dart' as http;
import '../../../../../../view/utils/app_constants.dart';

class GiriviListServices {
  final String url = AppUrl.giriviList;
  final apiKey = AppUrl.apiKey;

  Future<http.Response> giriviListApi({
    String? timezone,
    String? page,
    String? Search,
    String? FilterType,
    String? YearId,
    String? FormDate,
    String? ToDate,
  }) async {
    final headers = {
      AppString.apiKey: apiKey,
      AppString.logintokan: tokans,
      AppString.userid: userId,
    };

    final Map<String, dynamic> body = {
      AppString.timezone: timezone ?? '',
      AppString.page: page ?? '1',
      AppString.Search: Search ?? '',
      AppString.FilterType: FilterType ?? 'All',
      AppString.YearId: YearId ?? '0',
      AppString.FormDate: FormDate ?? '',
      AppString.ToDate: ToDate ?? '',
    };

    if (kDebugMode) {
      print('--- GiriviList API Request ---');
      print('URL: $url');
      print('Headers: $headers');
      print('Body: $body');
      print('--- GiriviList API Request ---');
    }

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );
  }
}
